class SurveyQuestion < ActiveRecord::Base
  validates :text, presence: true

  belongs_to :survey
  has_many :values, class_name: 'SurveyQuestionValue'
  has_many :answers, class_name: 'SurveyQuestionAnswer', inverse_of: :question
end
