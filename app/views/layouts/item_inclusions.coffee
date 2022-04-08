$ ->
  myNode = document.getElementById('item-inclusions-body')
  myNode.innerHTML = ''

  $('#item-inclusions-body').append('<%= j (raw render partial: 'layouts/item_inclusions') %>')
