$ ->
  window.image_queue = []
  window.settings ={interval_time:20000}
  image_box = $("#image_box")
  current_image = $("#current_image")
  top_nave = $("#top_nav")
  footer = $("#footer")
  get_next_image = (current_image)=>
    callback = (response)=>
      return null unless response.file
      current_image = $("#current_image")
      image = current_image.find("img")
      unless image[0]
        pageHeight = jQuery(window).height()-25
        img = $('<img class="current_image">')
        current_image.empty()
        img.css({'max-height':pageHeight+"px"})
        img.appendTo(current_image)
        image = current_image.find("img")
      window.image_queue.push(response.file)
      image.attr("src","file"+response.file)
    $.get "/next", {current_image}, callback, "json"

  clean_queue ()->
    while window.image_queue.length>50
      window.image_queue.shift()
  setInterval(clean_queue,window.settings.interval_time*6)

  create_image_rotate = () =>
    clearInterval(window.rotate_image_invterval) if window.rotate_image_invterval
    window.rotate_image_invterval = setInterval(()=>
      img  = $("#current_image").find("img")
      current_src = img.attr("src") if img
      console.log current_src
      get_next_image(current_src)
    ,window.settings.interval_time)

  get_next_image()
  create_image_rotate()
