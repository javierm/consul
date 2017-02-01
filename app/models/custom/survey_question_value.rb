class SurveyQuestionValue < ActiveRecord::Base
  validates :text, :question, presence: true

  belongs_to :question, class_name: 'SurveyQuestion', foreign_key: 'survey_question_id', inverse_of: :values
  has_many :answers, class_name: 'SurveyQuestionAnswer', inverse_of: :value
end
