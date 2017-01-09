class AnsweredSurvey < ActiveRecord::Base
  belongs_to :user
  belongs_to :survey
  has_many :survey_question_answers

  validates :user_id, uniqueness: { scope: :survey_id }

  accepts_nested_attributes_for :survey_question_answers, :allow_destroy => true

  def name
    self.survey_question_answers.first.survey_question_value.survey_question.survey.name
  end

  def survey
    self.survey_question_answers.first.survey_question_value.survey_question.survey
  end

end
