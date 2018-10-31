class SurveyQuestionAnswer < ActiveRecord::Base
  belongs_to :answered_survey, inverse_of: :answers
  belongs_to :value, class_name: 'SurveyQuestionValue', foreign_key: :survey_question_value_id, inverse_of: :answers
  belongs_to :question, class_name: 'SurveyQuestion', inverse_of: :answers, foreign_key: :survey_question_id

  delegate :text, to: :question, prefix: true
  delegate :text, to: :value, prefix: true, allow_nil: true

  # validates :value, :question, presence: true
  validates :answered_survey, presence: true, if: :value
  validate :only_one_answer_per_question

  #validate :only_one_answer_per_question

  private

    def only_one_answer_per_question
      return true unless value
      value_ids = value.question.value_ids - [ value.id ]
      coincident_answers = answered_survey.answers.select {|sqa| sqa.survey_question_value_id.in?(value_ids) }
      errors.add(:base, I18n.t('activerecord.errors.models.survey_question_answer.attributes.survey_question_value.question_already_answered')) unless coincident_answers.empty?
    end
end
