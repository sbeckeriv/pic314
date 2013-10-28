(function() {
  $(function() {
    var clean_queue, clear_deg, create_image_rotate, current_image, footer, get_current_deg, get_next_image, get_next_image_with_current, image_box, rotate_image, set_deg, set_image_url, top_nave,
      _this = this;
    window.image_queue = [];
    window.image_queue_playback = [];
    window.image_queue_current;
    window.pause = false;
    window.menu_interval;
    window.settings = {
      interval_time: 15000
    };
    image_box = $("#image_box");
    current_image = $("#current_image");
    top_nave = $("#top_nav");
    footer = $("#footer");
    get_current_deg = function() {
      var classes;
      current_image = $("img.current_image");
      classes = current_image.attr("class");
      if (classes.indexOf("deg_90") !== -1) {
        return 90;
      }
      if (classes.indexOf("deg_180") !== -1) {
        return 180;
      }
      if (classes.indexOf("deg_270") !== -1) {
        return 270;
      }
      return 0;
    };
    clear_deg = function() {
      var classes;
      current_image = $("img.current_image");
      classes = current_image.attr("class");
      return current_image.attr("class", classes.replace("deg_90", "").replace("deg_180", "").replace("deg_270", ""));
    };
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
        img.appendTo(current_image);
        image = current_image.find("img");
        image.photoResize();
      }
      src = response.file;
      clear_deg();
      if (skip !== true) {
        window.image_queue.unshift(src);
      }
      if (response.rotate != null) {
        image.attr("class", image.attr("class") + " deg_" + response.rotate);
      }
      return image.attr("src", "file" + src);
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
    $("#rotate_left").on("click", function() {
      return rotate_image(-90);
    });
    $("#rotate_right").on("click", function() {
      return rotate_image(90);
    });
    rotate_image = function(deg) {
      var current_deg;
      current_deg = get_current_deg();
      clear_deg();
      return set_deg((current_deg + deg + 360) % 360);
    };
    set_deg = function(deg) {
      var classes;
      current_image = $("img.current_image");
      classes = current_image.attr("class");
      return current_image.attr("class", classes + " deg_" + deg);
    };
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
    return create_image_rotate();
  });

}).call(this);
