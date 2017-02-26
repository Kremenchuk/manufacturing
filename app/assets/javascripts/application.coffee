
#= require jquery
#= require jquery_ujs
#= require bootstrap.min.js
#= require_tree .

$ ->
  document.getElementById("order-manufacturing-data").innerHTML = ''
  $.ajax
    url: order_manufacturings_path
    success: (data) ->
      $('#order-manufacturing-data').append(data);