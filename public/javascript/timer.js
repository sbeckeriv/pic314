(function() {
  var idleState, idleTimer, idleWait;

  idleTimer = null;

  idleState = true;

  idleWait = 5000;

  $(function() {
    return $("*").bind("mousemove keydown scroll", function() {
      clearTimeout(idleTimer);
      if (idleState === true) {
        $(window).trigger("user_active");
      }
      idleState = false;
      return idleTimer = setTimeout(function() {
        $(window).trigger("user_inactive");
        return idleState = true;
      }, idleWait);
    });
  });

}).call(this);
