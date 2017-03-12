
#= require jquery
#= require jquery_ujs
#= require bootstrap.min.js
#= require dataTables/jquery.dataTables

@checkboxChecked = (elem, $this) ->
  if elem.checked == true
    elem.checked = false
    $($this).closest('tr').toggleClass('datatable-checkbox-checked-tr')
  else
    elem.checked = true
    $($this).closest('tr').toggleClass('datatable-checkbox-checked-tr')


window.dataTableJson =
{

  "processing": "Подождите...",
  "search": "Поиск:",
  "lengthMenu": "Показать _MENU_ записей",
  "info": "Записи с _START_ до _END_ из _TOTAL_ записей",
  "infoEmpty": "Записи с 0 до 0 из 0 записей",
  "infoFiltered": "(отфильтровано из _MAX_ записей)",
  "infoPostFix": "",
  "loadingRecords": "Загрузка записей...",
  "zeroRecords": "Записи отсутствуют.",
  "emptyTable": "В таблице отсутствуют данные",
  "paginate": {
    "first": "Первая",
    "previous": "Предыдущая",
    "next": "Следующая",
    "last": "Последняя"
  },
  "aria": {
    "sortAscending": ": активировать для сортировки столбца по возрастанию",
    "sortDescending": ": активировать для сортировки столбца по убыванию"
  }

}

$ ->
  $('#payroll-table').dataTable(
    bServerSide: true
    sAjaxSource: $('#payroll-table').data('source')
    "language": window.dataTableJson)


  $('#order_manufacturing-table').dataTable(
    bServerSide: true
    sAjaxSource: $('#order_manufacturing-table').data('source')
    "language": window.dataTableJson)

  $('#item-table').dataTable(
    bServerSide: true
    sAjaxSource: $('#item-table').data('source')
    "language": window.dataTableJson)

  $('#job-table').dataTable(
    bServerSide: true
    sAjaxSource: $('#job-table').data('source')
    "language": window.dataTableJson)

  $('#worker-table').dataTable(
    bServerSide: true
    sAjaxSource: $('#worker-table').data('source')
    "language": window.dataTableJson)

  $('#counterparty-table').dataTable(
    bServerSide: true
    sAjaxSource: $('#counterparty-table').data('source')
    "language": window.dataTableJson)


$ ->
  $('body').on 'click', '.add_new_entity', ->
    elem = document.getElementsByClassName('datatable-checkbox')
    i = 0
    while i < elem.length
      elem[i].checked = false
      $(elem[i]).closest('tr').removeClass('datatable-checkbox-checked-tr')
      i++

  $('body').on 'click', '.datatable-checkbox', ->
    elem = document.getElementById(this.id)
    checkboxChecked elem, null

  $('body').on 'click', 'table#item-table tr', ->
    elem = document.getElementById($(this).find(':checkbox:eq(0)').attr('id'))
    checkboxChecked elem, this

