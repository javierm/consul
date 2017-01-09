class SurveyQuestion < ActiveRecord::Base
  validates :text, presence: true

  belongs_to :survey
  has_many :survey_question_values

end
