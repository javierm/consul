require "json"

require_dependency Rails.root.join("lib", "census_api").to_s

class CensusApi
  def call(document_type, document_number)
    response = nil
    get_document_number_variants(document_type, document_number).each do |variant|
      response = Response.new(get_response_body(document_type, variant))
      return response if response.valid?
    end
    response
  end

  class Response

    def valid?
      data[:datos_vivienda]["resultado"]
    end

    def date_of_birth
      str = data[:datos_habitante]["fecha_nacimiento"]
      day, month, year = str.match(/(\d\d?)\D(\d\d?)\D(\d\d\d?\d?)/)[1..3]
      return nil unless day.present? && month.present? && year.present?

      Time.zone.local(year.to_i, month.to_i, day.to_i).to_date
    end

    def postal_code
      data[:datos_vivienda]["codigo_postal"]
    end

    def district_code
      data[:datos_vivienda]["codigo_provincia"]
    end

    def gender
      case data[:datos_habitante]["sexo"]
      when "V" # H
        "male"
      when "M"
        "female"
      end
    end

    def name
      "#{data[:datos_habitante]["nombre"]} #{data[:datos_habitante]["apellido1"]}"
    end

    private

      def data
        @body
      end
  end

  class ConnectionCensus
    def initialize(path)
      @path = path
    end

    def call(document_number)
      data = {}
      data[:datos_habitante] = JSON.parse(get_age_validation(document_number))
      data[:datos_vivienda] = JSON.parse(get_residence_validation(document_number))
      data
    end

    private

    def get_age_validation(document_number)
      validator = Rails.application.secrets.census_api_age_validator
      `php -f #{@path}#{validator} -- -n #{document_number}`
    end

    def get_residence_validation(document_number)
      validator = Rails.application.secrets.census_api_residence_validator
      `php -f #{@path}#{validator} -- -n #{document_number}`
    end
  end

  private

    def get_response_body(document_type, document_number)
      if end_point_available?
        byebug
        client.call(document_number)
      else
        byebug
        stubbed_response(document_type, document_number)
      end
    end

    def client
      @client = ConnectionCensus.new(Rails.application.secrets.census_api_end_point)
    end

    def end_point_defined?
      Rails.application.secrets.census_api_end_point.present?
    end

    def end_point_available?
      (Rails.env.staging? || Rails.env.preproduction? || Rails.env.production?) &&end_point_defined?
    end

    def stubbed_response(document_type, document_number)
      if (document_number == "12345678Z" || document_number == "12345678Y") && document_type == "1"
        stubbed_valid_response
      else
        stubbed_invalid_response
      end
    end

    def stubbed_valid_response
      {
        datos_habitante: {
          nacinalidad: "España",
          nombre: "Francisca",
          apellido1: "Nomdedéu",
          apellido2: "Camps",
          sexo: "M",
          fecha_nacimiento: "19-10-1977"
        },
        datos_vivienda: {
          resultado: true,
          codigo_provincia: 46,
          descripcion_provincia: "Valencia",
          codigo_municipio: "Alzira",
          direccion: "C/ Piletes 9, 3º 11",
          codigo_postal: 46600
        }
      }
    end

    def stubbed_invalid_response
      { datos_habitante: {}, datos_vivienda: {}}
    end
end
