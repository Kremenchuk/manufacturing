# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  $('#payroll-li').click ->
    document.getElementById("payroll-data").innerHTML = ''
    $.ajax
      url: payrolls_path
      success: (data) ->
        $('#payroll-data').append(data);