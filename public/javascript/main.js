(function() {

  $(function() {
    var clean_queue, create_image_rotate, current_image, footer, get_next_image, get_next_image_with_current, image_box, set_image_url, top_nave,
      _this = this;
    window.image_queue = [];
    window.image_queue_playback = [];
    window.image_queue_current;
    window.pause = false;
    window.menu_interval;
    window.settings = {
      interval_time: 2000
    };
    image_box = $("#image_box");
    current_image = $("#current_image");
    top_nave = $("#top_nav");
    footer = $("#footer");
    $("body").mousemove(function() {
      if (window.menu_interval) {
        clearTimeout(window.menu_interval);
      }
      $(".menu").show();
      window.pause = true;
      return window.menu_interval = setTimeout(function() {
        window.pause = false;
        return $(".menu").hide();
      }, 10000);
    });
    set_image_url = function(response, skip) {
      var image, img, pageHeight, src;
      if (!response.file) {
        return null;
      }
      current_image = $("#current_image");
      image = current_image.find("img");
      if (!image[0]) {
        pageHeight = jQuery(window).height() - 25;
        img = $('<img class="current_image">');
        current_image.empty();
        img.css({
          'max-height': pageHeight + "px"
        });
        img.appendTo(current_image);
        image = current_image.find("img");
      }
      src = "file" + response.file;
      if (skip !== true) {
        window.image_queue.unshift(src);
      }
      return image.attr("src", src);
    };
    get_next_image = function(current_image) {
      return $.get("/next", {
        current_image: current_image
      }, set_image_url, "json");
    };
    get_next_image_with_current = function(skip_queue) {
      var current_src, image, img;
      if (window.image_queue_playback.length > 0) {
        image = window.image_queue_playback.pop();
        return set_image_url({
          file: image
        });
      }
      img = $("#current_image").find("img");
      if (img) {
        current_src = img.attr("src");
      }
      return get_next_image(current_src);
    };
    clean_queue = function() {
      var _results;
      _results = [];
      while (window.image_queue.length > 50) {
        _results.push(window.image_queue.pop());
      }
      return _results;
    };
    setInterval(clean_queue, window.settings.interval_time * 6);
    $("#next_control").on("click", function() {
      return get_next_image_with_current();
    });
    $("#prev_control").on("click", function() {
      var image;
      image = window.image_queue.shift();
      window.image_queue_playback.push(image);
      if (image != null) {
        return set_image_url({
          file: image
        }, true);
      }
    });
    create_image_rotate = function() {
      if (window.rotate_image_invterval) {
        clearInterval(window.rotate_image_invterval);
      }
      return window.rotate_image_invterval = setInterval(function() {
        if (!window.pause) {
          return get_next_image_with_current();
        }
      }, window.settings.interval_time);
    };
    get_next_image();
    create_image_rotate();
    return $(".menu").hide();
  });

}).call(this);
