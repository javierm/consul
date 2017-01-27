class SurveyQuestionAnswer < ActiveRecord::Base
  belongs_to :answered_survey
  belongs_to :value, class_name: 'SurveyQuestionValue', foreign_key: :survey_question_value_id
  belongs_to :question, class_name: 'SurveyQuestion', inverse_of: :answers, foreign_key: :survey_question_id

  delegate :text, to: :question, prefix: true
  delegate :text, to: :value, prefix: true

  #validate :only_one_answer_per_question

  private

    def only_one_answer_per_question
      questions = survey_question_value.survey_question.survey_question_value_ids
      answers = answered_survey.survey_question_answers.where(survey_question_value_id: questions).where.not(id: id)
      errors.add(:base, I18n.t('activerecord.errors.models.survey_question_answer.attributes.survey_question_value.question_already_answered')) unless answers.empty?
    end
end
