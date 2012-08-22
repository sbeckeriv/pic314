$ ->
  window.image_queue = []
  window.image_queue_playback = []
  window.image_queue_current 
  window.pause = false
  window.menu_interval 
  window.settings ={interval_time:15000}
  image_box = $("#image_box")
  current_image = $("#current_image")
  top_nave = $("#top_nav")
  footer = $("#footer")
  get_current_deg = () =>
    current_image = $("img.current_image")
    classes = current_image.attr("class")
    return 90 if classes.indexOf("deg_90")!=-1
    return 180 if classes.indexOf("deg_180")!=-1
    return 270 if classes.indexOf("deg_270")!=-1
    return 0
  clear_deg = () =>
    current_image = $("img.current_image")
    classes = current_image.attr("class")
    current_image.attr("class",classes.replace("deg_90","").replace("deg_180","").replace("deg_270",""))
  $("body").mousemove(() => 
    clearTimeout(window.menu_interval) if window.menu_interval
    $(".menu").show()
    window.pause = true
    window.menu_interval = setTimeout(()=>
      window.pause = false
      $(".menu").hide()
    , 10000)
  )
  
  set_image_url = (response,skip)=>
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
    src = response.file
    clear_deg()
    window.image_queue.unshift(src) unless skip==true
    image.attr("class", image.attr("class")+" deg_"+response.rotate) if response.rotate?
    image.attr("src","file"+src)

  get_next_image = (current_image)=>
    $.get "/next", {current_image}, set_image_url, "json"

  get_next_image_with_current = (skip_queue)=>
    if window.image_queue_playback.length > 0
      image = window.image_queue_playback.pop()
      return set_image_url({file:image})
    img  = $("#current_image").find("img")
    current_src = img.attr("src") if img
    get_next_image(current_src)

  clean_queue =  ()->
    while window.image_queue.length>50
      window.image_queue.pop()
  setInterval(clean_queue,window.settings.interval_time*6)

  $("#rotate_left").on("click", ()=>
    rotate_image(-90)
  )
  $("#rotate_right").on("click", ()=>
    rotate_image(90)
  )
  
  rotate_image = (deg)=>
    current_deg = get_current_deg()
    clear_deg()
    set_deg((current_deg+deg+360)%360)

  set_deg = (deg)=>
    current_image = $("img.current_image")
    classes = current_image.attr("class")
    current_image.attr("class", classes+" deg_"+deg)
  $("#next_control").on("click",()=>
    get_next_image_with_current()
  )

  $("#prev_control").on("click",()=>
    image = window.image_queue.shift()
    window.image_queue_playback.push(image)
    set_image_url({file:image},true) if image?
  )

  create_image_rotate = () =>
    clearInterval(window.rotate_image_invterval) if window.rotate_image_invterval
    window.rotate_image_invterval = setInterval(()=>
      get_next_image_with_current() unless window.pause
    ,window.settings.interval_time)

  get_next_image()
  create_image_rotate()

  $(".menu").hide()
