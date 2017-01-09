class Survey < ActiveRecord::Base
  validates :code, presence: true

  has_many :survey_questions
  has_many :answered_surveys

  def answer_for(user)
    answered_surveys.where(user_id: user.id).first
  end
end
