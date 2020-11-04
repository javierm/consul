require "rails_helper"

describe CensusApi do
  let(:api) { CensusApi.new }

  describe "#call" do
    let(:invalid_body) { { datos_habitante: {}, datos_vivienda: {}} }
    let(:valid_body) do
      {
        datos_habitante: {
          "nacinalidad" => "España",
          "nombre" => "Francisca",
          "apellido1" => "Nomdedéu",
          "apellido2" => "Camps",
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

    it "returns the response for the first valid variant" do
      allow(api).to receive(:get_response_body).with(1, "00123456").and_return(invalid_body)
      allow(api).to receive(:get_response_body).with(1, "123456").and_return(invalid_body)
      allow(api).to receive(:get_response_body).with(1, "0123456").and_return(valid_body)
      response = api.call(1, "0123456")

      expect(response).to be_valid
      expect(response.date_of_birth).to eq(Date.new(1977, 10, 19))
    end

    it "returns the last failed response" do
      allow(api).to receive(:get_response_body).with(1, "00123456").and_return(invalid_body)
      allow(api).to receive(:get_response_body).with(1, "123456").and_return(invalid_body)
      allow(api).to receive(:get_response_body).with(1, "0123456").and_return(invalid_body)
      response = api.call(1, "123456")

      expect(response).not_to be_valid
    end
  end
end
