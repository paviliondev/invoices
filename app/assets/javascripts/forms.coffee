jQuery(document).ready ($) ->
  $(document)
    .on 'click', '[data-toggle-field]', (e) ->
      $checkbox = $(this)
      field = $checkbox.data('toggle-field')
      $("[data-field='#{field}']").prop('disabled', !$checkbox.prop('checked'))