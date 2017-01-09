class SurveyQuestionAnswer < ActiveRecord::Base
  belongs_to :answered_survey
  belongs_to :survey_question_value

  def survey_answer
    self.survey_question_value.text
  end

  def survey_question
    self.survey_question_value.survey_question.text
  end
end
