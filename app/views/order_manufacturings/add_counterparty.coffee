#elem = document.getElementsByName('o_m_counterparty')
#console.log elem[0]
$('#counterparty').val('<%= j (@counterparty.name) %>')
#$(elem[0]).val('<%= j (@counterparty.name) %>')
$('#order_manufacturing_number').val('<%= j (@counterparty.short_name) %>' + '-')