
#= require jquery
#= require jquery_ujs
#= require bootstrap.min.js
#= require dataTables/jquery.dataTables
#= require jquery-ui/widgets/datepicker


@itemId = () ->
  item_id = document.getElementsByName('item_form')
  return $(item_id[0]).data('id')

@materialDetailsIds = () ->
  return $('.material_id_class').map(-> $(this).val()).get()

@piDetailsIds = () ->
  return $('.p_i_id_class').map(-> $(this).val()).get()

@itemDetailsIds = () ->
  ids = $('.item_id_class').map(-> $(this).val()).get()
  if $('#item_id').val()
    ids.push $('#item_id').val()
  console.log ids
  return ids

@jobDetailsIds = () ->
  return $('.job_id_class').map(-> $(this).val()).get()

@residualQty = () ->
  return $('.o_m_residual_qty_class').map(-> $(this).val()).get()

@checkboxChecked = (elem, $this) ->
  console.log elem.checked
  if elem.checked == true
    #elem.checked = false
    $($this).closest('tr').toggleClass('datatable-checkbox-checked-tr')
  else
    #elem.checked = true
    $($this).closest('tr').toggleClass('datatable-checkbox-checked-tr')

#Функція переміщення елементів таблиці по позиціях
@moveTrPositionDetails = (e, $this, i) ->
  e.preventDefault()
  element = $($this).closest('tr')
  position = parseInt($(element).attr("data-position"))
  new_position = position + i
  if new_position > document.getElementsByClassName('position_details_line').length
    return
  else
    if new_position < 1
      return
    else
      $(element).attr("data-position", new_position);
      if i > 0
        $(element.next()).attr("data-position", position);
        element.insertAfter(element.next())
      else
        $(element.prev()).attr("data-position", position);
        element.insertBefore(element.prev())

      i = 0
      table_element = document.getElementsByClassName('position_details_line')
      while i < table_element.length
        $(table_element[i].querySelector('.position-label')).html((i + 1))
        i++


#Функція обробки випадаючого меню
@hoverPositionLabel = ($this) ->
  $($this.querySelector('.position-menu')).stop(true).queue 'fx', ->
    $($this.querySelector('.position-menu')).toggle('normal').dequeue 'fx'
    return

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

# Ініціалізація jquery datatable
$(document).ready ->

  $('#payroll-table').DataTable
    bServerSide: true
    "language": window.dataTableJson,
    "pageLength": 20,
    "lengthMenu": [[10, 20, 50, 100], [10, 20, 50, 100]]
    ajax:
      url: $('#payroll-table').data('source')
      dataType: 'json'
      cache: false
      type: 'GET'
    columns: [
      { "data": "number" },
      { "data": "date" },
      { "data": "worker_fio" }
    ]

  #    'fnRowCallback': (nRow, aData, iDisplayIndex, iDisplayIndexFull) ->
  #      if aData[4] == '2'
  #        $('td', nRow).addClass '.in-work-status'

  $('#order_manufacturing-table').DataTable
    bServerSide: true
    #sAjaxSource: $('#order_manufacturing-table').data('source')
    "language": window.dataTableJson,
    "lengthMenu": [[10, 20, 50, 100], [10, 20, 50, 100]]
    "pageLength": 20,
    ajax:
      url: $('#order_manufacturing-table').data('source')
      dataType: 'json'
      cache: false
      type: 'GET'
    columns: [
      { "data": "start_date" },
      { "data": "finish_date" },
      { "data": "number" },
      { "data": "counterparty_name" },
      { "data": "invoice" }
      { "data": "o_m_status" }
    ]
    'fnRowCallback': (nRow, aData, iDisplayIndex) ->
      switch aData['o_m_status']
        when 'no_status'
          $('td', nRow).addClass 'no-status'
          $('td:eq(5)', nRow).html('Без статуса')
        when 'in_progress'
          $('td', nRow).addClass 'in-work-status'
          $('td:eq(5)', nRow).html('В работе')
        when 'produced'
          $('td', nRow).addClass 'finished-status'
          $('td:eq(5)', nRow).html('Изготовлен')
        when 'shipped'
          $('td', nRow).addClass 'shipped-status'
          $('td:eq(5)', nRow).html('Отгружен')


  $('#purchase_invoice-table').DataTable
    bServerSide: true
    "language": window.dataTableJson,
    "pageLength": 20,
    "lengthMenu": [[10, 20, 50, 100], [10, 20, 50, 100]]
    ajax:
      url: $('#purchase_invoice-table').data('source')
      dataType: 'json'
      cache: false
      type: 'GET'
    columns: [
      { "data": "number" },
      { "data": "date" },
      { "data": "counterparty_name" },
      { "data": "p_i_status" },
    ]
    'fnRowCallback': (nRow, aData, iDisplayIndex) ->
      switch aData['p_i_status']
        when 0
          $('td', nRow).addClass 'no-status'
          $('td:eq(3)', nRow).html('Без статуса')
        when 1
          $('td', nRow).addClass 'shipped-status'
          $('td:eq(3)', nRow).html('ОПРИХОДОВАНО НА СКЛАД')


  $('#item-table').DataTable
    bServerSide: true
    "language": window.dataTableJson,
    "pageLength": 20,
    "lengthMenu": [[10, 20, 50, 100], [10, 20, 50, 100]]
    ajax:
      url: $('#item-table').data('source')
      dataType: 'json'
      cache: false
      type: 'GET'
    columns: [
      { "data": "name" },
      { "data": "unit" },
      { "data": "price" },
      { "data": "weight" },
      { "data": "item_group"}
    ]

  $('#material-table').DataTable
    bServerSide: true
    "language": window.dataTableJson,
    "pageLength": 20,
    "lengthMenu": [[10, 20, 50, 100], [10, 20, 50, 100]]
    ajax:
      url: $('#material-table').data('source')
      dataType: 'json'
      cache: false
      type: 'GET'
    columns: [
      { "data": "name" },
      { "data": "unit" },
      { "data": "qty" },
      { "data": "price" }
    ]

  $('#job-table').DataTable
    bServerSide: true
    "language": window.dataTableJson,
    "pageLength": 20,
    "lengthMenu": [[10, 20, 50, 100], [10, 20, 50, 100]]
    ajax:
      url: $('#job-table').data('source')
      dataType: 'json'
      cache: false
      type: 'GET'
    columns: [
      { "data": "name" },
      { "data": "name_for_print" },
      { "data": "price" },
      { "data": "time" }
    ]

  $('#worker-table').DataTable
    bServerSide: true
    "language": window.dataTableJson,
    "pageLength": 20,
    "lengthMenu": [[10, 20, 50, 100], [10, 20, 50, 100]]
    ajax:
      url: $('#worker-table').data('source')
      dataType: 'json'
      cache: false
      type: 'GET'
    columns: [
      { "data": "fio" },
      { "data": "position" }
    ]

  $('#counterparty-table').DataTable
    bServerSide: true
    #sAjaxSource: $('#counterparty-table').data('source')
    "language": window.dataTableJson,
    "pageLength": 20,
    "lengthMenu": [[10, 20, 50, 100], [10, 20, 50, 100]]
    ajax:
      url: $('#counterparty-table').data('source')
      dataType: 'json'
      cache: false
      type: 'GET'
    columns: [
      { "data": "name" },
      { "data": "short_name" },
      { "data": "c_type" }
    ]


# Відмічає виділений елемент

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

  $('body').on 'click', 'table#item-details-datatable tr', ->
    elem = document.getElementById($(this).find(':checkbox:eq(0)').attr('id'))
    checkboxChecked elem, this

  $('body').on 'click', 'table#job-details-datatable tr', ->
    elem = document.getElementById($(this).find(':checkbox:eq(0)').attr('id'))
    checkboxChecked elem, this

  $('body').on 'click', 'table#o_m-details-datatable tr', ->
    elem = document.getElementById($(this).find(':checkbox:eq(0)').attr('id'))
    checkboxChecked elem, this

  $('body').on 'click', 'table#counterparties-o_m-datatable tr', ->
    elem = document.getElementById($(this).find(':checkbox:eq(0)').attr('id'))
    checkboxChecked elem, this


# Перевірка обов'язкових полів на заповненість

  $('.submit-form').submit ->
    validate_fields = document.getElementById(this.id).getElementsByClassName('validate-field')
    i = 0
    submitting_bool = true
    while i < validate_fields.length
      validate_field = $('#' + validate_fields[i].id)
      unless validate_field.val()
        validate_field.addClass('error-class')
        submitting_bool = false
      i++
    if submitting_bool
      $(this).submit()
    else
      return false

  $('.form-control').on 'change', (e) ->
    $(this).removeClass('error-class')

  # Випадаюче меню для зміни position
  $(document).on 'mouseenter', '.position', ->
    hoverPositionLabel(this)
  # Випадаюче меню для зміни position
  $(document).on 'mouseleave', '.position', ->
    hoverPositionLabel(this)

  #Видалення позиції
  $(document).on 'click', '.remove_row', (e) ->
    id = $(this).data('counter')
    $(this).closest('tr').remove()
    i = 0
    table_element = document.getElementsByClassName('position_details_line')
    while i < table_element.length
      $(table_element[i]).attr("data-position", (i + 1));
      $(table_element[i].querySelector('.position-label')).html((i + 1))
      i++


  $('#item_group_in_item').on 'change', (e) ->
    filterGlobal()

  filterGlobal = ->
    $('#item-table').DataTable().search($('#item_group_in_item').val()).draw()


  $('#item_group_in_o_m_d').on 'change', (e) ->
    filterGlobalOM()

  filterGlobalOM = ->
    $('#o_m-details-datatable').DataTable().search($('#item_group_in_o_m_d').val()).draw()

$(document).on 'change', '#change_locale', ->
  custId = $(this).val()
  $.ajax
    type: "PUT"
    url: "/change_user_locale"
    dataType: "html"
    data:
      locale: $(this).val()
    success: (result) ->
      document.write(result)
      document.close()
  return


