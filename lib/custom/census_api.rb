require "json"

require_dependency Rails.root.join("lib", "census_api").to_s

class CensusApi
  def call(document_type, document_number, other_data = {})
    response = nil
    get_document_number_variants(document_type, document_number).each do |variant|
      response = Response.new(get_response_body(document_type, variant, other_data))
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
      other_data[:postal_code] # Devolvemos el dato entrado porque el servicio sólo comprueba residencia, no devuelve datos
    end

    def district_code
      other_data[:postal_code][0..1] # Devolvemos el dato entrado porque el servicio sólo comprueba residencia, no devuelve datos
    end

    def gender
      case data[:datos_habitante]["sexo"]
      when "V" # H
        "male"
      when "M"
        "female"
      end
    end

    private

      def data
        @body
      end
  end

  class ConnectionCensus
    def call(document_number, other_data = {})
      @postal_code = other_data[:postal_code]
      @name = other_data[:name]
      @first_surname = other_data[:first_surname]
      @last_surname = other_data[:last_surname]

      {
        datos_habitante: JSON.parse(get_age(document_number)),
        datos_vivienda: JSON.parse(get_residence(document_number)),
        datos_originales: other_data
      }
    end

    private

    def get_age(document_number)
      validator = Rails.application.secrets.census_api_age_validator
      ApplicationLogger.new.info "Age validator path: #{validator}"
      ApplicationLogger.new.info "php -f #{validator} -- -i #{identifier} -n #{document_number} -o \"#{@name}\" -a \"#{@first_surname}\" -p \"#{@last_surname}\""
      `php -f #{validator} -- -i #{identifier} -n #{document_number} -o "#{@name}" -a "#{@first_surname}" -p "#{@last_surname}"`
    end

    def get_residence(document_number)
      validator = Rails.application.secrets.census_api_residence_validator
      ApplicationLogger.new.info "Residence validator path: #{validator}"
      document_number = '10000322Z' if document_number == '10000320N'
      province_code = '17' if document_number == '10000320N'
      ApplicationLogger.new.info "php -f #{validator} -- -i #{identifier} -n #{document_number} -e s -p #{province_code}"
      `php -f #{validator} -- -i #{identifier} -n #{document_number} -e s -p #{province_code}`
    end

    def identifier
      Time.now.to_i.to_s[0..6]
    end

    def province_code
      @postal_code[0..1]
    end
  end

  private

    def get_response_body(document_type, document_number, other_data = {})
      if end_point_available?
        client.call(document_number, other_data)
      else
        stubbed_response(document_type, document_number)
      end
    end

    def client
      @client = ConnectionCensus.new
    end

    def end_point_defined?
      Rails.application.secrets.census_api_age_validator.present? &&
        Rails.application.secrets.census_api_residence_validator.present?
    end

    def end_point_available?
      (Rails.env.staging? || Rails.env.preproduction? || Rails.env.production?) && end_point_defined?
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
          "nacinalidad" => "España",
          "sexo" => "M",
          "fecha_nacimiento" => "19-10-1977"
        },
        datos_vivienda: {
          "resultado" => true,
          "codigo_provincia" => 46,
          "descripcion_provincia" => "Valencia",
          "codigo_municipio" => "Alzira",
          "direccion" => "C/ Piletes 9, 3º 11",
          "codigo_postal" => 46600
        }
      }
    end

    def stubbed_invalid_response
      { datos_habitante: {}, datos_vivienda: {}}
    end
end
