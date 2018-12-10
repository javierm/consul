require 'csv'

# csv_text = File.read(Rails.root.join('db', 'demo_users.csv'))
# csv = CSV.parse(csv_text, :headers => false, col_sep: ';')

csv_survey = File.read(Rails.root.join('db', 'demo_questions.csv'))
csv_questions = CSV.parse(csv_survey, :headers => false, col_sep: ';')

# puts "Creating Users"
#
# def create_user(email, username = nil)
#   pwd = '12345678'
#   puts "    #{username}"
#   user = User.where(username: username, email: email).first_or_initialize
#   if user.new_record?
#     user.password_confirmation = pwd
#     user.password = pwd
#   end
#   user.confirmed_at = Time.now
#   user.terms_of_service = "1"
#   user.save!
#   user
# end

# csv.each_with_index do |row, i|
#     puts row
#     a = create_user(row.last, row.first)
#     a.update(residence_verified_at: Time.now, confirmed_phone: "9#{i.to_s*8}", document_type: "1", verified_at: Time.now, document_number:i.to_s*8 )
# end

# Datos de encuesta inicial
puts "Creating Survey"

def create_survey

  survey = Survey.where(code: "ENC-4").first_or_initialize
  if survey.new_record?
    survey.name = "Encuesta Igualdad"
    survey.description ="<p>Desde la Consejería de Área de Política Social y Accesibilidad del Cabildo de Gran Canaria nos encontramos en la fase de diseño del I Plan Insular de Drogas y Adicciones de Gran Canaria. Desde nuestra visión, la participación de la ciudadanía es fundamental para la elaboración de dicho plan, por lo que les pedimos su colaboración respondiendo a este breve cuestionario. La información obtenida de este sondeo nos resultará de gran utilidad para establecer un diagnóstico de la cuestión.</p>\n\n<p>Para contestar a las preguntas deberá registrarse en la plataforma (le llevará solo dos minutos de su tiempo). Asimismo, les informamos que el cuestionario es totalmente anónimo, por lo que sus datos no se verán expuestos.</p>"
    survey.start = Date.today
    survey.end = '15/12/2018'
  end
  survey.save!
  survey
end

survey = create_survey()
question_num = 0
csv_questions.each_with_index do |row, i|
  puts row
  survey_question = SurveyQuestion.where(text: row[2], survey_id: survey.id).first_or_initialize
  if survey_question.new_record?
    survey_question.code = question_num
    survey_question.input_type = row[3]
    question_num =+ 1
    survey_question.survey = survey
    survey_question.save!
  end
  if !row[1].blank?
    survey_value = SurveyQuestionValue.where(text: row[1], order: row[0], survey_question_id: survey_question).first_or_initialize
    survey_value.question = survey_question
    survey_value.save!
  end
end


