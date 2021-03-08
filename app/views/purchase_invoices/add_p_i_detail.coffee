$ ->
  console.log 'add_material to p_i'
#  i =  document.getElementsByClassName('p_i_details_line').length
  $('#p_i-details-table-body').append('<%= j (raw render partial: 'p_i_detail') %>')

  #  table_element = document.getElementsByClassName('p_i_details_line')
  #  while i < table_element.length
  #    $(table_element[i]).attr("data-position", (i + 1));
  #    $(table_element[i].querySelector('.position-label')).html((i + 1))
  #    i++