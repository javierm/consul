class SurveyQuestionValue < ActiveRecord::Base
  validates :text, presence: true

  belongs_to :question, class_name: 'SurveyQuestion'
  has_many :answers, class_name: 'SurveyQuestionAnswer'
end
