$ ->
  myNode = document.getElementById('o_m-write-off-materials-table-body')
  myNode.innerHTML = ''

  $('#o_m-write-off-materials-table-body').append('<%= j (raw render partial: 'o_m_write_off_materials') %>')
