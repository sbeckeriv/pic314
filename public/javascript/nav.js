(function() {
  $(function() {
    $(".menu").hide();
    $(".navbar-inner").hide();
    $(".navbar-toggle").on("click", function() {
      return $(".navbar-inner").show();
    });
    $(window).on("user_active", function() {
      return $(".menu").show();
    });
    return $(window).on("user_inactive", function() {
      $(".navbar-inner").hide();
      return $(".menu").hide();
    });
  });

}).call(this);
