# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on 'turbolinks:load', ->
  changeConnectionMethod()
  if($(".bootstrap-filestyle").length == 0)
    $(":file").filestyle()

changeConnectionMethod= ->
  $(".password").removeClass("hidden").find(":input").prop('disabled', false);
  $(".private_key").addClass("hidden").find(":input").prop('disabled', true);
  $(".passphrase").addClass("hidden").find(":input").prop('disabled', true);
  $(".select_method").change ->
    if($(this).val() == 'By private key')
      $(".password").toggleClass("hidden").find(":input").prop('disabled', true);
      $(".private_key").toggleClass("hidden").find(":input").prop('disabled', false);
      $(".passphrase").toggleClass("hidden").find(":input").prop('disabled', false);
    else
      $(".password").toggleClass("hidden").find(":input").prop('disabled', false);
      $(".private_key").toggleClass("hidden").find(":input").prop('disabled', true);
      $(".passphrase").toggleClass("hidden").find(":input").prop('disabled', true);
    