require "rails_helper"

describe "Residence" do
  let(:other_data) do
    {
      name: 'Francisca',
      first_surname: 'Nomdedéu',
      last_surname: 'Camps',
      date_of_birth: '1977-10-19'.to_date,
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

  before do
    create(:geozone)
    expect_any_instance_of(CensusApi).to receive(:get_response_body).with('1', '12345678Z', other_data).and_return(valid_body)
  end

  scenario "Verify resident" do
    user = create(:user)
    login_as(user)

    visit account_path
    click_link "Verify my account"

    fill_in "residence_name", with: "Francisca"
    fill_in "residence_first_surname", with: "Nomdedéu"
    fill_in "residence_last_surname", with: "Camps"
    fill_in "residence_document_number", with: "12345678Z"
    select "DNI", from: "residence_document_type"
    select_date "19-October-1977", from: "residence_date_of_birth"
    fill_in "residence_postal_code", with: "46100"
    select "Male", from: "residence_gender"
    check "residence_terms_of_service"
    click_button "Verify residence"

    expect(page).to have_content "Account verified"
  end

  scenario "Verify resident above 12 years" do
    user = create(:user)
    login_as(user)

    valid_body[:datos_originales][:date_of_birth] = 13.years.ago.to_date
    valid_body[:datos_habitante]['fecha_nacimiento'] = 13.years.ago.strftime('%Y%m%d')

    visit account_path
    click_link "Verify my account"

    fill_in "residence_name", with: "Francisca"
    fill_in "residence_first_surname", with: "Nomdedéu"
    fill_in "residence_last_surname", with: "Camps"
    fill_in "residence_document_number", with: "12345678Z"
    select "DNI", from: "residence_document_type"
    select_date 13.years.ago.strftime('%d-%B-%Y'), from: "residence_date_of_birth"
    fill_in "residence_postal_code", with: "46100"
    select "Male", from: "residence_gender"
    check "residence_terms_of_service"
    click_button "Verify residence"

    # We don't have english translations
    # flash appears as missing translation
    expect(page).to have_content "required_age_request_form"
    # Bottom message as string
    expect(page).to have_content "Required Age Verification Request"
  end

  scenario "Verify foreign resident" do
    user = create(:user)
    login_as(user)

    valid_body[:datos_originales][:postal_code] = '36100'

    visit account_path
    click_link "Verify my account"

    fill_in "residence_name", with: "Francisca"
    fill_in "residence_first_surname", with: "Nomdedéu"
    fill_in "residence_last_surname", with: "Camps"
    fill_in "residence_document_number", with: "12345678Z"
    select "DNI", from: "residence_document_type"
    select_date "19-October-1977", from: "residence_date_of_birth"
    fill_in "residence_postal_code", with: "36100"
    check "residence_foreign_residence"
    select "Male", from: "residence_gender"
    check "residence_terms_of_service"
    click_button "Verify residence"

    # We don't have english translations
    # flash appears as missing translation
    expect(page).to have_content "foreign_residence_request_form"
    # Bottom message as string
    expect(page).to have_content "Foreign Residence Verification Request"
  end

  scenario "Verify foreign resident above 12 years" do
    user = create(:user)
    login_as(user)

    valid_body[:datos_originales][:postal_code] = '36100'
    valid_body[:datos_originales][:date_of_birth] = 13.years.ago.to_date
    valid_body[:datos_habitante]['fecha_nacimiento'] = 13.years.ago.strftime('%Y%m%d')

    visit account_path
    click_link "Verify my account"

    fill_in "residence_name", with: "Francisca"
    fill_in "residence_first_surname", with: "Nomdedéu"
    fill_in "residence_last_surname", with: "Camps"
    fill_in "residence_document_number", with: "12345678Z"
    select "DNI", from: "residence_document_type"
    select_date 13.years.ago.strftime('%d-%B-%Y'), from: "residence_date_of_birth"
    fill_in "residence_postal_code", with: "36100"
    check "residence_foreign_residence"
    select "Male", from: "residence_gender"
    check "residence_terms_of_service"
    click_button "Verify residence"

    # We don't have english translations
    # flash appears as missing translation
    expect(page).to have_content "required_age_foreign_residence_request_form"
    # Bottom message as string
    expect(page).to have_content "Required Age Foreign Residence Verification Request"
  end

  scenario "Error on residence" do
    user = create(:user)
    login_as(user)

    valid_body[:datos_originales][:postal_code] = '36100'

    visit account_path
    click_link "Verify my account"

    fill_in "residence_name", with: "Francisca"
    fill_in "residence_first_surname", with: "Nomdedéu"
    fill_in "residence_last_surname", with: "Camps"
    fill_in "residence_document_number", with: "12345678Z"
    select "DNI", from: "residence_document_type"
    select_date "19-October-1977", from: "residence_date_of_birth"
    fill_in "residence_postal_code", with: "36100"
    select "Male", from: "residence_gender"
    check "residence_terms_of_service"

    click_button "Verify residence"

    expect(page).to have_content(/\d errors? prevented the verification of your residence/)
    expect(page).to have_content("In order to be verified, you must be registered")
  end
end
