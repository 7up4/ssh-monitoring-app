# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on 'turbolinks:load', ->
  changeConnectionMethod()
  if($(".bootstrap-filestyle").length == 0)
    $(":file").filestyle({buttonName: "btn-primary"})

changeConnectionMethod= ->
  toggle_fields($(".select_method"))
  $(".select_method").change ->
    $(":file").filestyle({buttonName: "btn-primary"})
    toggle_fields($(this))
    
toggle_fields = (selector) -> 
  if(selector.val() == 'By private key')
    $(".password").addClass("hidden").find(":input").prop('disabled', true);
    $(".private_key").removeClass("hidden").find(":input").prop('disabled', false);
    $(".passphrase").removeClass("hidden").find(":input").prop('disabled', false);
  else
    $(".password").removeClass("hidden").find(":input").prop('disabled', false);
    $(".private_key").addClass("hidden").find(":input").prop('disabled', true);
    $(".passphrase").addClass("hidden").find(":input").prop('disabled', true);