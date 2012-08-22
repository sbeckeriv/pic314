require "rubygems"
require "pp"
require "mail"
require "gmail"
require 'digest/md5'
require "fileutils"

unless ARGV[0] && ARGV[1]
  puts "No username and pass"
  exit
end

username = ARGV[0]
photo_path = File.join(File.expand_path("~"),"photos",username.gsub(/[^a-zA-Z0-9_\.\@]/, '_'))
FileUtils.mkdir_p(photo_path)
pass = ARGV[1]
filter = ARGV[2] ? ARGV[2].to_sym : :unread
delete = ARGV[3]

class Mail::Part
  def file_type(sub_type)
    case sub_type
    when /jpg|jpeg/i
      "jpg"
    else
      sub_type.to_s.downcase
    end
  end

  #Ripped from the rdocs
  def save_to_file(path=nil)
    return false unless attachment?
    fname = path if path && !File.exists?(path) # If path doesn't exist, assume it's a filename
    fname ||= path + '/' + filename if path && File.directory?(path) # If path does exist, and we're saving an attachment, use the attachment filename
    fname ||= (path || filename) # Use the path, or the attachment filename
    if File.directory?(fname)
      i = 0
      begin
        i += 1
        fname = fname + "/attachment-#{i}"
      end until !File.exists(fname)
    end
    # After all that trouble to get a filename to save to...
    File.open(fname, 'w') { |f| f << read }
  end

  def save_to_md5_name(path)
    return false unless attachment?
    raise("Need a path") if path && !File.exists?(path) # If path doesn't exist, assume it's a filename
    file = read
    digest = Digest::MD5.hexdigest(file)
    file_name = File.join(path,digest)
    pp file_name
    type = file_type(sub_type)
    File.open("#{file_name}.#{type}", 'w') { |f| f << file}
  end
end

gmail = Gmail.new(username, pass)
gmail.inbox.emails(filter).each{|m|
  m.mark(:read)
  m.attachments.each{|a|
    if(a.content_type.match(/image|png|jpg|jpeg|tif|gif|bmp/))
      a.save_to_md5_name(photo_path)
    end
  }
  m.delete! if delete
}
