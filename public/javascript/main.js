(function() {

  $(function() {
    var current_image, footer, get_next_image, image_box, top_nave,
      _this = this;
    window.image_queue = [];
    image_box = $("#image_box");
    current_image = $("#current_image");
    top_nave = $("#top_nav");
    footer = $("#footer");
    get_next_image = function(current_image) {
      var callback;
      callback = function(response) {
        var image, img, pageHeight;
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
        window.image_queue.push(response.file);
        return image.attr("src", "file" + response.file);
      };
      return $.get("/next", {
        current_image: current_image
      }, callback, "json");
    };
    setInterval(function() {
      var current_src, img;
      img = $("#current_image").find("img");
      if (img) {
        current_src = img.attr("src");
      }
      console.log(current_src);
      return get_next_image(current_src);
    }, 20000);
    return get_next_image();
  });

}).call(this);
