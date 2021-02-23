$ ->
  myNode = document.getElementById('o_m-used-materials-table-body')
  myNode.innerHTML = ''
  myNode = document.getElementById('o_m-used-jobs-table-body')
  myNode.innerHTML = ''

  $('#o_m-used-materials-table-body').append('<%= j (raw render partial: 'o_m_used_materials') %>')

  $('#o_m-used-jobs-table-body').append('<%= j (raw render partial: 'o_m_used_jobs') %>')
