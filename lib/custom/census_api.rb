require_dependency Rails.root.join("lib", "census_api").to_s

class CensusApi
  def call(document_type, document_number)
    response = nil
    get_document_number_variants(document_type, document_number).each do |variant|
      response = Response.new(get_response_body(variant))
      return response if response.valid?
    end
    response
  end

  class Response
    def valid?
      data["estado"] == "1"
    end

    def date_of_birth
      str = data["fechaNacimiento"]
      year, month, day = str.match(/^(\d\d\d\d)(\d\d)(\d\d)/)[1..3]
      return nil unless day.present? && month.present? && year.present?

      Time.zone.local(year.to_i, month.to_i, day.to_i).to_date
    end

    def postal_code
      Base64.decode64 data["codigoPostal"]
    end

    def district_code
      data["distrito"]
    end

    def gender
      case Base64.decode64(data["sexo"])
      when "V"
        "male"
      when "M"
        "female"
      end
    end

    def name
      name = Base64.decode64(data["nombre"])
      surname1 = Base64.decode64(data["apellido1"])
      "#{name} #{surname1}"
    end

    private

      def data
        parse_response @body["servicioResponse"]["servicioReturn"]
      end

      def parse_response(response)
        service_response_h = Hash.from_xml response
        service_response_h["s"]["par"]
      end
  end

  private

    def get_response_body(document_number)
      if end_point_available?
        operation = Rails.application.secrets.census_api_operation
        response = client.call(operation.to_sym, message: request(document_number))
        h = Hash.from_xml(response.xml)
        h["Envelope"]["Body"]
      else
        stubbed_response(document_number)
      end
    end

    def request(document_number)
      secrets = Rails.application.secrets
      sec = get_security_fields(secrets.census_api_public_key)

      data = { e:
               { ope:
                   { apl: "PAD",
                     tobj: "HAB",
                     cmd: "CONSULTAINDIVIDUAL",
                     ver: "2.0"
                   },
                 sec:
                   { cli: secrets.census_api_cli,
                     org: 0,
                     ent: 0,
                     usu: secrets.census_api_user_code,
                     pwd: Digest::SHA1.base64digest(secrets.census_api_pwd),
                     fecha: sec[:date],
                     nonce: sec[:nonce],
                     token: sec[:token]
                   },
                 par:
                   { documento: Base64.strict_encode64(document_number),
                     busquedaExacta: 0
                   }
               }
             }

      xml = Gyoku.xml data
      "<sml><![CDATA[#{xml}]]></sml>"
    end

    def stubbed_response(document_number)
      if document_number == "12345678Z"
        stubbed_valid_response
      else
        stubbed_invalid_response
      end
    end

    def stubbed_valid_response
      data = {
               s: {
                 par: {
                   estado: "1",
                   fechaNacimiento: "19801231000000",
                   nombre: Base64.encode64("José"),
                   apellido1: Base64.encode64("García"),
                   sexo: Base64.encode64("V"),
                   codigoPostal: Base64.encode64("28013"),
                   codigoDistrito: "01"
                 }
               }
            }
      { "servicioResponse" => { "servicioReturn" => Gyoku.xml(data) }}
    end

    def stubbed_invalid_response
      data = {
               s: {
                 par: {
                   estado: "0",
                   fechaNacimiento: "",
                   nombre: "",
                   apellido1: "",
                   sexo: "",
                   codigoPostal: "",
                   codigoDistrito: ""
                 }
               }
            }
      { "servicioResponse" => { "servicioReturn" => Gyoku.xml(data) }}
    end

    def get_security_fields(public_key)
      date = DateTime.now.gregorian
      created = date.strftime("%Y%m%d%H%M%S")
      nonce = SecureRandom.random_number(9e17).to_i.to_s.rjust(18, "0")[0..17]
      origin = "#{nonce}#{created}#{public_key}"
      token = Digest::SHA512.base64digest origin
      { date: created, nonce: nonce, token: token }
    end
end
