# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  $('#order-manufacturing-li').click ->
    document.getElementById("order-manufacturing-data").innerHTML = ''
    $.ajax
      url: order_manufacturing_index_path
      success: (data) ->
        $('#order-manufacturing-data').append(data);



