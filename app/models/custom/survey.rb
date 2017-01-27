class Survey < ActiveRecord::Base
  validates :code, presence: true

  has_many :questions, class_name: 'SurveyQuestion'
  has_many :answered_surveys

  def answer_for(user)
    answered_surveys.where(user_id: user.id).first
  end
end
