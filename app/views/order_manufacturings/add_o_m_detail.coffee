$ ->
  $('#o_m-details-table-body').append('<%= j render partial: 'o_m_detail', locals: {items: @o_m_details} %>')

  table_element = document.getElementsByClassName('position_details_line')
  i = 0
  while i < table_element.length
    $(table_element[i]).attr("data-position", (i + 1));
    $(table_element[i].querySelector('.position-label')).html((i + 1))
    i++