idleTimer = null
idleState = true
idleWait = 5000

$ ->
  $("*").bind "mousemove keydown scroll", ->
    clearTimeout idleTimer
    
    # Reactivated event
    $(window).trigger("user_active")  if idleState is true
    idleState = false
    idleTimer = setTimeout(->
      # Idle Event
      $(window).trigger("user_inactive")  
      idleState = true
    , idleWait)


