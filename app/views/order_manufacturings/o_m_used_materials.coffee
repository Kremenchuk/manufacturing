$ ->
  myNode = document.getElementById('o_m-used-materials-table-body')
  myNode.innerHTML = ''


  $('#o_m-used-materials-table-body').append('<%= j (raw render partial: 'o_m_used_materials') %>')


