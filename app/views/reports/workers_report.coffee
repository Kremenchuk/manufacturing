$ ->
  myNode = document.getElementById('workers-report-table-body')
  myNode.innerHTML = ''

  $('#workers-report-table-body').append('<%= j (raw render partial: 'workers_report') %>')
  $('#workers_report_modal_link').click()
