
#= require jquery
#= require jquery_ujs
#= require bootstrap.min.js
#= require dataTables/jquery.dataTables



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