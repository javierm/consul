class SurveyQuestionValue < ActiveRecord::Base
  validates :text, presence: true

  belongs_to :survey_question
  has_many :survey_question_answers
end
