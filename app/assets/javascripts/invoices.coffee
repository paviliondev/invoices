jQuery(document).ready ($) ->
  $('#js-copy-address').on 'click', (e) ->
    e.preventDefault()
    shippingAddress = $('[data-address="shipping"]')
    shippingAddress.val($('[data-address="invoice"]').val())
    autosize.update(shippingAddress)
    
  $("#invoice_customer_id").select2()
  $("#invoice_customer_id").on "select2:select", (e) ->
    data = e.params.data
    ['name',
     'identification',
     'contact_person',
     'email',
     'invoicing_address',
     'shipping_address'].forEach (f) ->
       $("#invoice_#{f}").prop('disabled', data.id == "")
       $("#invoice_#{f}").val($(data.element).data(f))

  if window.location.pathname == Routes.invoices_path()
    # Chart
    chartDisplayed = false
    $('#js-section-info').on 'shown.bs.collapse', ->
      if not chartDisplayed
        chartDisplayed = true
        $.getJSON Routes.chart_data_invoices_path({format: 'json'}) + window.location.search, (data) ->
          columns = [['Labels'], ['Total']]

          $.each data, (key, value) ->
            columns[0].push key
            columns[1].push value

          chart = c3.generate
            bindto: '#js-invoices-chart'
            data:
              type: 'area-step'
              x: 'Labels'
              columns: columns
            axis:
              x:
                type: 'timeseries'
                tick:
                  format: '%d %b'
            grid:
              y:
                show: true
            legend:
              show: false
