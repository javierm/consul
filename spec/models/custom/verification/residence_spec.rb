require "rails_helper"

describe Verification::Residence do
  let(:residence) { build(:verification_residence, document_number: "12345678Z", gender: "other") }

  describe "validations" do
    describe "postal code" do
      it "is valid with postal codes starting with 03, 12 or 46" do
        residence.postal_code = "03001"
        residence.valid?
        expect(residence.errors[:postal_code]).to be_empty

        residence.postal_code = "12001"
        residence.valid?
        expect(residence.errors[:postal_code]).to be_empty

        residence.postal_code = "46001"
        residence.valid?
        expect(residence.errors[:postal_code]).to be_empty
      end

      it "is not valid with postal codes not starting with 03, 12 or 46" do
        residence.postal_code = "13280"
        residence.valid?
        expect(residence.errors[:postal_code].size).to eq(1)

        residence.postal_code = "13280"
        residence.valid?
        expect(residence.errors[:postal_code]).to eq ["In order to be verified, you must be registered."]
      end
    end
  end

  describe "gender" do
    describe "presence validation" do
      before do
        residence.valid?
      end
      it { expect(residence.errors[:gender]).to be_empty }

      describe "failed" do
        before do
          residence.gender = nil
          residence.valid?
        end

        it { expect(residence.errors[:gender]).to eq ["can't be blank"] }
      end
    end
  end

  describe 'dates' do
    it "validates user is not allowed under 12 years old" do
      residence = Verification::Residence.new("date_of_birth(3i)" => "1",
                                      "date_of_birth(2i)" => "1",
                                      "date_of_birth(1i)" => 11.years.ago.year.to_s)
      expect(residence).to_not be_valid
      expect(residence.errors[:date_of_birth]).to include("You don't have the required age to participate")
    end

    it "validates user has allowed age above 12 years old" do
      residence = Verification::Residence.new("date_of_birth(3i)" => "1",
                                      "date_of_birth(2i)" => "1",
                                      "date_of_birth(1i)" => 13.years.ago.year.to_s)
      expect(residence).to_not be_valid
      expect(residence.errors[:date_of_birth]).to_not include("You don't have the required age to participate")
    end

    it "validates user still has allowed age above 16 years old" do
      residence = Verification::Residence.new("date_of_birth(3i)" => "1",
                                      "date_of_birth(2i)" => "1",
                                      "date_of_birth(1i)" => 17.years.ago.year.to_s)
      expect(residence).to_not be_valid
      expect(residence.errors[:date_of_birth]).to_not include("You don't have the required age to participate")
    end
  end

  describe "save" do
    let(:other_data) do
      {
        name: 'Francisca',
        first_surname: 'Nomdedéu',
        last_surname: 'Camps',
        date_of_birth: '19771019',
        postal_code: '46100'
      }
    end

    let(:valid_body) do
      {
        datos_habitante: {
          "resultado" => true,
          "error" => false,
          "cod_estado" => "00",
          "literal_error" => "INFORMACION CORRECTA",
          "nacionalidad" => "ESPAÑA",
          "nombre" => "Francisca",
          "apellido1" => "Nomdedéu",
          "apellido2" => "Camps",
          "sexo" => "M",
          "fecha_nacimiento" => "19771019"
        },
        datos_vivienda: {
          "resultado" => true,
          "error" => false,
          "estado" => "0003",
          "literal" => "Verificación positiva. Ámbito Territorial de Residencia Correcto.",
        },
        datos_originales: other_data
      }
    end

    let(:invalid_age_body) do
      valid_body.merge({ datos_habitante: { "resultado" => false, "error" => 'error servicio edad' } })
    end

    let(:invalid_residence_body) do
      valid_body.merge({ datos_vivienda: { "resultado" => false, "error" => 'error servicio residencia' } })
    end

    let(:unavailable_age_body) do
      valid_body.merge({ datos_habitante: { "resultado" => false, "error" => 'Servicio no disponible...' } })
    end

    let(:unavailable_residence_body) do
      valid_body.merge({ datos_vivienda: { "resultado" => false, "error" => 'Servicio no disponible...' } })
    end

    describe "residence in valencia and age above 16 years old" do
      let(:residence) { build(:verification_residence, document_number: "12345678Z", document_type: '1', gender: 'female', postal_code: '46100', date_of_birth: '19771019'.to_date, name: 'Francisca', first_surname: 'Nomdedéu') }
      let!(:geozone) { create(:geozone, census_code: "46") }
      let(:now) { Time.zone.now }

      before do
        Timecop.freeze(now)
        allow_any_instance_of(CensusCaller).to receive(:call).and_return(CensusApi::Response.new(valid_body))
      end

      after do
        Timecop.return
      end

      it "stores all required fields" do
        user = create(:user)
        residence.user = user
        residence.save!

        user.reload
        expect(user.document_number).to eq("12345678Z")
        expect(user.document_type).to eq("1")
        expect(user.date_of_birth.year).to eq(1977)
        expect(user.date_of_birth.month).to eq(10)
        expect(user.date_of_birth.day).to eq(19)
        expect(user.gender).to eq("female")
        expect(user.geozone).to eq(geozone)
        expect(user.postal_code).to eq(other_data[:postal_code])
        expect(user.residence_verified_at).to eq(now)
        expect(user.residence_requested_at).to eq(nil)
        expect(user.foreign_residence).to eq(nil)
        expect(user.services_results).to eq(JSON.parse(valid_body.to_json))
      end
    end

    describe "residence in valencia and age above 12 years old" do
      let(:age) { 12.years.ago }
      let(:residence) { build(:verification_residence, document_number: "12345678Z", document_type: '1', gender: 'female', postal_code: '46100', date_of_birth: age.to_date, name: 'Francisca', first_surname: 'Nomdedéu') }
      let!(:geozone) { create(:geozone, census_code: "46") }
      let(:now) { Time.zone.now }

      before do
        Timecop.freeze(now)
        valid_body[:datos_habitante]['fecha_nacimiento'] = age.strftime('%Y%m%d')
        valid_body[:datos_originales]['date_of_birth'] = age.strftime('%Y%m%d')
        allow_any_instance_of(CensusCaller).to receive(:call).and_return(CensusApi::Response.new(valid_body))
      end

      after do
        Timecop.return
      end

      it "stores all required fields" do
        user = create(:user)
        residence.user = user
        residence.save!

        user.reload
        expect(user.document_number).to eq("12345678Z")
        expect(user.document_type).to eq("1")
        expect(user.date_of_birth.year).to eq(age.year)
        expect(user.date_of_birth.month).to eq(age.month)
        expect(user.date_of_birth.day).to eq(age.day)
        expect(user.gender).to eq("female")
        expect(user.geozone).to eq(geozone)
        expect(user.postal_code).to eq(other_data[:postal_code])
        expect(user.residence_verified_at).to eq(nil)
        expect(user.residence_requested_at).to eq(now)
        expect(user.foreign_residence).to eq(nil)
        expect(user.services_results).to eq(JSON.parse(valid_body.to_json))

        expect(user.residence_requested_age?).to equal(true)
        expect(user.residence_requested_foreign?).to equal(false)
      end
    end

    describe "born in valencia but residence outside and age above 16" do
      let(:age) { 16.years.ago }
      let(:postal_code) { '46100' }
      let(:residence) { build(:verification_residence, document_number: "12345678Z", document_type: '1', gender: 'female', postal_code: postal_code, foreign_residence: '1', date_of_birth: age.to_date, name: 'Francisca', first_surname: 'Nomdedéu') }
      let!(:geozone) { create(:geozone, census_code: "46") }
      let(:now) { Time.zone.now }

      after do
        Timecop.return
      end

      describe "with 0231 code (Documento incorrecto)" do
        before do
          Timecop.freeze(now)
          valid_body[:datos_habitante]['fecha_nacimiento'] = age.strftime('%Y%m%d')
          valid_body[:datos_originales]['date_of_birth'] = age.strftime('%Y%m%d')
          valid_body[:datos_originales]['postal_code'] = postal_code
          valid_body[:datos_vivienda]['resultado'] = false
          valid_body[:datos_vivienda]['error'] = "0231 Documento incorrecto"
          allow_any_instance_of(CensusCaller).to receive(:call).and_return(CensusApi::Response.new(valid_body))
        end

        it "does not save user" do
          user = create(:user)
          residence.user = user
          expect { residence.save! }.to raise_exception(ActiveModel::ValidationError).with_message('Validation failed: Residence in valencia false')
        end
      end

      describe "with 0233 code (Titular no identificado o ámbito de residencia incorrecto" do
        before do
          Timecop.freeze(now)
          valid_body[:datos_habitante]['fecha_nacimiento'] = age.strftime('%Y%m%d')
          valid_body[:datos_originales]['date_of_birth'] = age.strftime('%Y%m%d')
          valid_body[:datos_originales]['postal_code'] = postal_code
          valid_body[:datos_vivienda]['resultado'] = false
          valid_body[:datos_vivienda]['error'] = false
          valid_body[:datos_vivienda]['estado'] = "0233"
          allow_any_instance_of(CensusCaller).to receive(:call).and_return(CensusApi::Response.new(valid_body))
        end

        it "stores all required fields" do
          user = create(:user)
          residence.user = user
          residence.save!

          user.reload
          expect(user.document_number).to eq("12345678Z")
          expect(user.document_type).to eq("1")
          expect(user.date_of_birth.year).to eq(age.year)
          expect(user.date_of_birth.month).to eq(age.month)
          expect(user.date_of_birth.day).to eq(age.day)
          expect(user.gender).to eq("female")
          expect(user.geozone).to eq(geozone)
          expect(user.postal_code).to eq('46100')
          expect(user.residence_verified_at).to eq(nil)
          expect(user.residence_requested_at).to eq(now)
          expect(user.foreign_residence).to eq(true)
          expect(user.services_results).to eq(JSON.parse(valid_body.to_json))

          expect(user.residence_requested_age?).to equal(false)
          expect(user.residence_requested_foreign?).to equal(true)
        end
      end

      describe "with 0239 code (Error al tratar los datos. Municipio inexistente..." do
        before do
          Timecop.freeze(now)
          valid_body[:datos_habitante]['fecha_nacimiento'] = age.strftime('%Y%m%d')
          valid_body[:datos_originales]['date_of_birth'] = age.strftime('%Y%m%d')
          valid_body[:datos_originales]['postal_code'] = postal_code
          valid_body[:datos_vivienda]['resultado'] = false
          valid_body[:datos_vivienda]['error'] = "0239 Error al tratar"
          allow_any_instance_of(CensusCaller).to receive(:call).and_return(CensusApi::Response.new(valid_body))
        end

        it "does not save user" do
          user = create(:user)
          residence.user = user
          expect { residence.save! }.to raise_exception(ActiveModel::ValidationError).with_message('Validation failed: Residence in valencia false')
        end
      end
    end

    describe "born in valencia and resident in valencia but foreign residence checked and age above 16" do
      let(:age) { 16.years.ago }
      let(:postal_code) { '46100' }
      let(:residence) { build(:verification_residence, document_number: "12345678Z", document_type: '1', gender: 'female', postal_code: postal_code, foreign_residence: '1', date_of_birth: age.to_date, name: 'Francisca', first_surname: 'Nomdedéu') }
      let!(:geozone) { create(:geozone, census_code: "46") }
      let(:now) { Time.zone.now }

      before do
        Timecop.freeze(now)
        valid_body[:datos_habitante]['fecha_nacimiento'] = age.strftime('%Y%m%d')
        valid_body[:datos_originales]['date_of_birth'] = age.strftime('%Y%m%d')
        valid_body[:datos_originales]['postal_code'] = postal_code
        valid_body[:datos_vivienda]['resultado'] = true
        allow_any_instance_of(CensusCaller).to receive(:call).and_return(CensusApi::Response.new(valid_body))
      end

      after do
        Timecop.return
      end

      it "stores all required fields with verified" do
        user = create(:user)
        residence.user = user
        residence.save!

        user.reload
        expect(user.document_number).to eq("12345678Z")
        expect(user.document_type).to eq("1")
        expect(user.date_of_birth.year).to eq(age.year)
        expect(user.date_of_birth.month).to eq(age.month)
        expect(user.date_of_birth.day).to eq(age.day)
        expect(user.gender).to eq("female")
        expect(user.geozone).to eq(geozone)
        expect(user.postal_code).to eq('46100')
        expect(user.residence_verified_at).to eq(now)
        expect(user.residence_requested_at).to eq(nil)
        expect(user.foreign_residence).to eq(true)
        expect(user.services_results).to eq(JSON.parse(valid_body.to_json))

        expect { user.residence_requested_age? }.to raise_exception # no birth date
        expect(user.residence_requested_foreign?).to equal(true)
      end
    end

    describe "born in valencia but residence outside and age above 12" do
      let(:age) { 12.years.ago }
      let(:postal_code) { '46100' }
      let(:residence) { build(:verification_residence, document_number: "12345678Z", document_type: '1', gender: 'female', postal_code: postal_code, foreign_residence: '1', date_of_birth: age.to_date, name: 'Francisca', first_surname: 'Nomdedéu') }
      let!(:geozone) { create(:geozone, census_code: "46") }
      let(:now) { Time.zone.now }

      before do
        Timecop.freeze(now)
        valid_body[:datos_habitante]['fecha_nacimiento'] = age.strftime('%Y%m%d')
        valid_body[:datos_originales]['date_of_birth'] = age.strftime('%Y%m%d')
        valid_body[:datos_originales]['postal_code'] = postal_code
        valid_body[:datos_vivienda]['resultado'] = false
        valid_body[:datos_vivienda]['estado'] = '0233'
        allow_any_instance_of(CensusCaller).to receive(:call).and_return(CensusApi::Response.new(valid_body))
      end

      after do
        Timecop.return
      end

      it "stores all required fields" do
        user = create(:user)
        residence.user = user
        residence.save!

        user.reload
        expect(user.document_number).to eq("12345678Z")
        expect(user.document_type).to eq("1")
        expect(user.date_of_birth.year).to eq(age.year)
        expect(user.date_of_birth.month).to eq(age.month)
        expect(user.date_of_birth.day).to eq(age.day)
        expect(user.gender).to eq("female")
        expect(user.geozone).to eq(geozone)
        expect(user.postal_code).to eq('46100')
        expect(user.residence_verified_at).to eq(nil)
        expect(user.residence_requested_at).to eq(now)
        expect(user.foreign_residence).to eq(true)
        expect(user.services_results).to eq(JSON.parse(valid_body.to_json))

        expect(user.residence_requested_age?).to equal(true)
        expect(user.residence_requested_foreign?).to equal(true)
      end
    end
  end
end
