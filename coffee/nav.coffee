$ ->
  $(".menu").hide()
  $(".navbar-inner").hide()

  $(".navbar-toggle").on "click", ->
    $(".navbar-inner").show()

  $(window).on "user_active", ->
    $(".menu").show()

  $(window).on "user_inactive", ->
    $(".navbar-inner").hide()
    $(".menu").hide()



 
  
