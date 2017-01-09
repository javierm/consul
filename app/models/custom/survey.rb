class Survey < ActiveRecord::Base
  validates :code, presence: true

  has_many :survey_questions

end
