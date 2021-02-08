require_dependency Rails.root.join("app", "models", "setting").to_s

class Setting
  class << self
    alias_method :consul_defaults, :defaults

    def defaults
      consul_defaults.merge({
        "mailer_from_address": "participa@lorca.es",
        "remote_census.general.endpoint": Rails.application.secrets.census_api_end_point,
        "remote_census.request.date_of_birth": nil,
        "remote_census.request.document_number": "get_habita_datos.request.documento",
        "remote_census.request.document_type": "get_habita_datos.request.tipo_documento",
        "remote_census.request.method_name": "get_habita_datos",
        "remote_census.request.postal_code": nil,
        "remote_census.request.structure": %Q({ "request":
          {
            "codigo_institucion": "#{Rails.application.secrets.census_api_institution_code}",
            "codigo_portal": "#{Rails.application.secrets.census_api_portal_name}",
            "codigo_usuario": "#{Rails.application.secrets.census_api_user_code}",
            "documento": "null",
            "tipo_documento": "null",
            "codigo_idioma": 102,
            "nivel": 3
          }
        }),
        "remote_census.response.date_of_birth": "datos_habitante.item.fecha_nacimiento_string",
        "remote_census.response.district": "datos_vivienda.item.codigo_distrito",
        "remote_census.response.postal_code": "datos_vivienda.item.codigo_postal",
        "remote_census.response.gender": "datos_habitante.item.descripcion_sexo",
        "remote_census.response.name": "datos_habitante.item.nombre",
        "remote_census.response.surname": "datos_habitante.item.apellido1",
        "remote_census.response.valid": "datos_habitante.item"
      })
    end
  end
end
