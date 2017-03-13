$('#item-details-table-body').data('ids', JSON.parse('<%= @item_details_ids %>'))
$('#item-details-table-body').append('<%= j (raw render @item_details) %>')

