class AnsweredSurvey < ActiveRecord::Base
  belongs_to :user
  belongs_to :survey
  has_many :answers, class_name: 'SurveyQuestionAnswer', inverse_of: :answered_survey, dependent: :destroy

  validates :survey, :user, presence: true
  validates :user_id, uniqueness: { scope: :survey_id }
  # validate :validate_all_questions_answered

  delegate :name, to: :survey
  accepts_nested_attributes_for :answers, :allow_destroy => true

  def validate_all_questions_answered
    errors.add(:base, I18n.t('activerecord.errors.models.survey_question_answer.not_all_answered')) if answers.any? {|q| q.survey_question_value_id.nil?}
  end
end

