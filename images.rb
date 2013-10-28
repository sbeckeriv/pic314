$LOAD_PATH.unshift(File.dirname(__FILE__))
require "sinatra"
require "pp"
begin
  require "v8"
  require "coffee-script"
  COFFEESCRIPT = true
rescue Exception
  COFFEESCRIPT=false
end
require "haml"
require 'sass'
require 'json'
require 'lib/random_array.rb'

include Rack::Utils

set :scss, :style => :compressed

set :image_dir , File.join(File.expand_path("~",),"photos")
set :haml, :format => :html5

helpers do
  include Rack::Utils
end

before do
  build_coffee_script if COFFEESCRIPT
end

get '/css/:filename' do
  scss :"/scss/#{params["filename"].to_s.split(".css").first}"
end

get '/' do
  haml :index
end

get '/next' do
  content_type :json
  {:file=>get_next_image(params["current_image"])}.to_json
end

get /file(\/.*)/ do |load_path|
  content_type "image/jpeg"
  cache_control :public, :must_revalidate, :max_age => 6000
  File.read(load_path)
end


def get_next_image(current=nil)
  current = current.sub!("file/","") if current
  Dir.glob(File.join(settings.image_dir,"**","*")).reject{|file| !File.file?(file) || current && file.include?(current)}.random
end

def build_coffee_script
  current_root  = File.expand_path(File.dirname(__FILE__))
  source = File.join(current_root,"coffee")
  javascripts = File.join(current_root,"public","javascript")
  concated_file = ""
  Dir.foreach(source) do |cf|
    if cf.match(/.+\.coffee\z/)
      begin
        js = CoffeeScript.compile File.read(File.join(source,cf))
        open File.join(javascripts,cf.gsub('.coffee', '.js')), 'w' do |f|
          concated_file+= "\n\n//#{cf}\n#{js}"
          f.puts js
        end
      rescue => e
        puts cf
        puts e.message
        raise e
      end
    end
  end

  open File.join(javascripts,"application.js"), 'w' do |f|
    f.puts concated_file
  end
end

