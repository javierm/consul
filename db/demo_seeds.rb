require 'csv'

csv_text = File.read(Rails.root.join('db', 'demo_users.csv'))
csv = CSV.parse(csv_text, :headers => false, col_sep: ';')

csv_survey = File.read(Rails.root.join('db', 'demo_questions.csv'))
csv_questions = CSV.parse(csv_survey, :headers => false, col_sep: ';')

puts "Creating Users"

def create_user(email, username = nil)
  pwd = '12345678'
  puts "    #{username}"
  user = User.where(username: username, email: email).first_or_initialize
  if user.new_record?
    user.password_confirmation = pwd
    user.password = pwd
  end
  user.confirmed_at = Time.now
  user.terms_of_service = "1"
  user.save!
  user
end

csv.each_with_index do |row, i|
    puts row
    a = create_user(row.last, row.first)
    a.update(residence_verified_at: Time.now, confirmed_phone: "9#{i.to_s*8}", document_type: "1", verified_at: Time.now, document_number:i.to_s*8 )
end

# Datos de encuesta inicial
puts "Creating Survey"

def create_survey
  survey = Survey.where(code: "ENC-1").first_or_initialize
  if survey.new_record?
    survey.name = "Encuesta El Confital"
    survey.description = "En el proceso participativo que vamos a lanzar próximamente, junto al Ayuntamiento de Las Palmas de Gran Canaria, para definir los usos y actividades en El Confital, se hace necesaria la realización de una encuesta entre la ciudadanía con la finalidad de tener un conocimiento más certero de quiénes son los usuarios de este espacio y cómo interactúan con él. <br>Es por ello que te pedimos que cumplimenten el cuestionario que te presentamos a continuación."
    survey.start = Date.today
    survey.end = survey.end = Date.today + 90
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
    question_num =+ 1
  end
  survey_question.survey = survey
  survey_question.save!

  survey_value = SurveyQuestionValue.where(text: row[1], order: row[0]).first_or_initialize
  survey_value.question = survey_question
  survey_value.save!
end


