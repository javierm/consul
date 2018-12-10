require 'csv'

# csv_text = File.read(Rails.root.join('db', 'demo_users.csv'))
# csv = CSV.parse(csv_text, :headers => false, col_sep: ';')

csv_survey = File.read(Rails.root.join('db', 'demo_questions_old.csv'))
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
  survey = Survey.where(code: "ENC-3").first_or_initialize
  if survey.new_record?
    survey.name = "Encuesta Igualdad"
    survey.description ="<p>Un equipo de investigadoras e investigadores de la Universidad de Las Palmas de Gran Canaria está realizando un análisis diagnóstico de la <strong>(Des) Igualdad por razón de sexo, orientación sexual o identidad de género en la isla de Gran Canaria</strong>. Este análisis forma parte del <strong>Marco Estratégico de Igualdad</strong> que el Cabildo Insular, a través de la Consejería de Igualdad y Participación Ciudadana, pondrá en marcha a partir del próximo año 2019.</p>\n\n<p>La participación ciudadana es una aportación esencial en este proceso. Por este motivo, se establece un proceso de consulta ciudadana a través del Portal de Participación del Cabildo de Gran Canaria, invitando a la ciudadanía a responder al cuestionario.</p>\n\n<p>En el cuestionario se solicita que responda a una serie de cuestiones agrupadas en dos Bloques. El primero referido a sus percepciones sobre la desigualdad y las discriminaciones por razón del sexo, orientación sexual e identidad de género, y en el Bloque II sus aportacione<p>En el cé necesidades y acciones debieran tratarse en el Marco Estratégico de Igualdad a diseñar para el próximo año. Previamente le solicitamos algunos datos de clasificación.</p>\n\n<p>Para la cumplimentación del cuestionario, se ruega se ajuste a las indicaciones en cada una de las preguntas (elegir una única opción; elegir las 3 opciones más importantes…). No obstante, nos ponemos a su disposición para aclararle cualquier cuestión relativa a la cumplimentación del presente documento (e-mail: jorgeg.cuesta@gmail.com, teléfono: 928 219421 | Ext 54014 | Ext 44514, en horario de 8 a 14 h). <strong>Le agradecemos de antemano la atención y el tiempo empleado.</strong></p>"
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
  survey_question = SurveyQuestion.where(text: row[2]).first_or_initialize
  if survey_question.new_record?
    survey_question.code = question_num
    survey_question.input_type = row[3]
    question_num =+ 1
    survey_question.survey = survey
    survey_question.save!
  end
  if !row[1].blank?
    survey_value = SurveyQuestionValue.where(text: row[1], order: row[0]).first_or_initialize
    survey_value.question = survey_question
    survey_value.save!
  end
end


