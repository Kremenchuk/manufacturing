$ ->
  $('#item-details-table-body').append('<%= j (render partial: 'item_detail') %>')

  table_element = document.getElementsByClassName('position_details_line')
  i = 0
  while i < table_element.length
    $(table_element[i]).attr("data-position", (i + 1));
    $(table_element[i].querySelector('.position-label')).html((i + 1))
    i++

