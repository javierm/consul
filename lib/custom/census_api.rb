require "json"

require_dependency Rails.root.join("lib", "census_api").to_s

class CensusApi
  def call(document_type, document_number, other_data = {})
    response = Response.new(get_response_body(document_type, document_number, other_data))
    response if response.valid?
  end

  class Response

    def valid?
      data[:datos_vivienda]["resultado"]
    end

    def date_of_birth
      str = data[:datos_habitante]['fecha_nacimiento']
      year, month, day = str.match(/(\d\d\d\d)(\d\d)(\d\d)/)[1..3]
      return nil unless day.present? && month.present? && year.present?

      Time.zone.local(year.to_i, month.to_i, day.to_i).to_date
    end

    def postal_code
      data[:datos_originales][:postal_code] # Devolvemos el dato entrado porque el servicio sólo comprueba residencia, no devuelve datos
    end

    def district_code
      data[:datos_originales][:postal_code][0..1] # Devolvemos el dato entrado porque el servicio sólo comprueba residencia, no devuelve datos
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
      result = if Rails.env.development?
                 CensusApi.new.send(:stubbed_valid_response)[:datos_habitante].to_json
               else
                 validator = Rails.application.secrets.census_api_age_validator
                 ApplicationLogger.new.warn "Age validator path: #{validator}"
                 ApplicationLogger.new.warn "php -f #{validator} -- -i #{identifier} -n #{document_number} -o \"#{@name}\" -a \"#{@first_surname}\" -p \"#{@last_surname}\""
                 `php -f #{validator} -- -i #{identifier} -n #{document_number} -o "#{@name}" -a "#{@first_surname}" -p "#{@last_surname}"`
               end
      ApplicationLogger.new.warn "result: #{result}"
      result
    end

    def get_residence(document_number)
      result = if Rails.env.development?
                 CensusApi.new.send(:stubbed_valid_response)[:datos_vivienda].to_json
               else
                 validator = Rails.application.secrets.census_api_residence_validator
                 ApplicationLogger.new.warn "Residence validator path: #{validator}"
                 # La persona de pruebas en servicio de residencia es diferente que en el servicio de edad
                 # Cambiamos los valores aquí para que en caso de que llegue del formulario el de prueba, aquí ponga los datos necesarios.
                 if Rails.application.secrets.environment == 'development' && document_number.upcase == '10000320N'
                   document_number = '10000322Z'
                   province_code = '17'
                 else
                   province_code = @postal_code[0..1]
                 end
                 ApplicationLogger.new.warn "province_code: #{province_code}"
                 ApplicationLogger.new.warn "php -f #{validator} -- -i #{identifier} -n #{document_number} -e s -p #{province_code}"
                 `php -f #{validator} -- -i #{identifier} -n #{document_number} -e s -p #{province_code}`
               end
      ApplicationLogger.new.warn "result: #{result}"
      result
    end

    def identifier
      Time.now.to_i.to_s[-7..-1]
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
      # values from php scripts test data
      {
        datos_habitante: {
          "resultado" => true,
          "error" => false,
          "cod_estado" => "cod. estado ok",
          "literal_estado" => "lit. estado ok",
          "nacionalidad" => "España",
          "sexo" => "M",
          "fecha_nacimiento" => "20030518"
        },
        datos_vivienda: {
          "resultado" => true,
          "error" => false,
          "cod_estado" => "cod. estado ok",
          "literal_estado" => "lit. estado ok"
        }
      }
    end

    def stubbed_invalid_response
      {
        datos_habitante: {
          "resultado" => false,
          "error" => "Algún error",
          "cod_estado" => "cod. estado no ok",
          "literal_estado" => "lit. estado no ok"
        },
        datos_vivienda: {
          "resultado" => false,
          "error" => "Algún error",
          "cod_estado" => "cod. estado no ok",
          "literal_estado" => "lit. estado no ok"
        }
      }
    end
end
