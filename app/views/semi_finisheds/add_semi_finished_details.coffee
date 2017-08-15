$ ->
  i = document.getElementsByClassName('item_details_line').length
  $('#semi_finished-details-table-body').append('<%= j (raw render partial: 'semi_finished_detail') %>')

  table_element = document.getElementsByClassName('item_details_line')
  while i < table_element.length
    $(table_element[i]).attr("data-position", (i + 1));
    $(table_element[i].querySelector('.position-label')).html((i + 1))
    i++

