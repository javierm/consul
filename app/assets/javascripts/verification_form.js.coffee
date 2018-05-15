App.VerificationForm =

  initialize: ->

    $('#residence_no_resident').change ->
      if $(this).prop('checked')
        $('#residence_geozone_id').prop('disabled', true)
        $('#residence_postal_code').prop('readonly', true)
        $('#residence_terms_of_service').prop('checked', false)
      else
        $('#residence_geozone_id').prop('disabled', false)
        $('#residence_postal_code').prop('readonly', false)
        $('#residence_terms_of_service').prop('checked', true)

    $('#residence_terms_of_service').change ->
      $('#residence_no_resident').prop('checked', !$(this).prop('checked')).trigger('change')

