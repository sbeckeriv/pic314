$ ->
  window.image_queue = []
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
  setInterval(()=>
    img  = $("#current_image").find("img")
    current_src = img.attr("src") if img
    console.log current_src
    get_next_image(current_src)
  ,20000)

  get_next_image()
