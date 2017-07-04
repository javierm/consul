class PersonApi

  def call(document_type, document_number, official_name, official_document_number)
    response = nil
    get_document_number_variants(document_type, document_number).each do |variant|
      response = Response.new(get_response_body(document_type, variant, official_name, official_document_number))
      return response if response.valid?
    end
    response
  end

  def get_document_number_variants(document_type, document_number)
    # Delete all non-alphanumerics
    document_number = document_number.to_s.gsub(/[^0-9A-Za-z]/i, '')
    variants = []

    if is_dni?(document_type)
      document_number, letter = split_letter_from(document_number)
      number_variants = get_number_variants_with_leading_zeroes_from(document_number)
      letter_variants = get_letter_variants(number_variants, letter)

      variants += number_variants
      variants += letter_variants
    else # if not a DNI, just use the document_number, with no variants
      variants << document_number
    end

    variants
  end

  class Response
    def initialize(body)
      @body = body
    end

    def valid?
      data[:datos_solicitante].present?
    end

    def date_of_birth
      str = data[:datos_solicitante][:datos_nacimiento][:fecha]
      year, month, day = str.match(/(\d\d\d\d)(\d\d)(\d\d)/)[1..3]
      return nil unless day.present? && month.present? && year.present?
      Date.new(year.to_i, month.to_i, day.to_i)
    end

    private

      def data
        @body[:consultar_datos_response]
      end
  end

  private

    def get_response_body(document_type, document_number, official_name, official_document_number)
      if end_point_available?
        client.call(:consultar_datos, message: request(document_type, document_number, official_name, official_document_number)).body
      else
        stubbed_response_body
      end
    end

    def client
      @client = Savon.client(wsdl: Rails.application.secrets.person_api_end_point, endpoint: Rails.application.secrets.person_api_end_point)
    end

    def request(document_type, document_number, official_name, official_document_number)
      ActiveSupport::OrderedHash[
        'Solicitante', ActiveSupport::OrderedHash[
          'tipoIdentificacion', document_type,
          'identificacion', document_number
        ],
        'Finalidad', ActiveSupport::OrderedHash[
          'codProcedimiento', 'N-125',
          'nombreProcedimiento', 'TI010',
          'idExpediente', 'EXP001.000',
          'textoFinalidad', 'Consultar Datos'
        ],
        'Funcionario', ActiveSupport::OrderedHash[
          'nombreCompleto', official_name,
          'identificacion', official_document_number
        ],
        'consentimiento', 'Si'
      ]
    end

    def end_point_available?
      Rails.application.secrets.person_api_end_point.present?
    end

    def stubbed_response_body
      {:consultar_datos_response => {:resultado_operacion=>{:codigo_error=>"ESB-0000", :descripcion=>"OK", :codigo_estado=>nil, :descripcion_estado=>nil}, :datos_solicitante=>{:tipo_identificacion=>"DNI", :identificacion=>"12345678Z", :nombre=>"NOMBRE", :apellido1=>"APELLIDO1", :apellido2=>"APELLIDO2", :nacionalidad=>"ESPAÑA-ESP", :sexo=>"M", :datos_nacimiento=>{:fecha=>"19700101", :localidad=>"LAS PALMAS DE GRAN CANARIA", :provincia=>"LAS PALMAS"}, :nom_padre=>"PADRE", :nom_madre=>"MADRE", :fecha_caducidad=>"20180101"}}}
    end

    def is_dni?(document_type)
      document_type.to_s == "1"
    end

    def split_letter_from(document_number)
      letter = document_number.last
      if letter[/[A-Za-z]/] == letter
        document_number = document_number[0..-2]
      else
        letter = nil
      end
      return document_number, letter
    end

    # if the number has less digits than it should, pad with zeros to the left and add each variant to the list
    # For example, if the initial document_number is 1234, and digits=8, the result is
    # ['1234', '01234', '001234', '0001234']
    def get_number_variants_with_leading_zeroes_from(document_number, digits=8)
      document_number = document_number.to_s.last(digits) # Keep only the last x digits
      document_number = document_number.gsub(/^0+/, '')   # Removes leading zeros

      variants = []
      variants << document_number unless document_number.blank?
      while document_number.size < digits
        document_number = "0#{document_number}"
        variants << document_number
      end
      variants
    end

    # Generates uppercase and lowercase variants of a series of numbers, if the letter is present
    # If number_variants == ['1234', '01234'] & letter == 'A', the result is
    # ['1234a', '1234A', '01234a', '01234A']
    def get_letter_variants(number_variants, letter)
      variants = []
      if letter.present? then
        number_variants.each do |number|
          variants << number + letter.downcase << number + letter.upcase
        end
      end
      variants
    end
end
