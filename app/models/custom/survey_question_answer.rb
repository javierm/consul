class SurveyQuestionAnswer < ActiveRecord::Base
  belongs_to :answered_survey
  belongs_to :survey_question_value

  validate :only_one_answer_per_question

  def survey_answer
    self.survey_question_value.text
  end

  def survey_question
    self.survey_question_value.survey_question.text
  end

  private

    def only_one_answer_per_question
      questions = survey_question_value.survey_question.survey_question_value_ids
      answers = answered_survey.survey_question_answers.where(survey_question_value_id: questions).where.not(id: id)
      errors.add(:base, I18n.t('activerecord.errors.models.survey_question_answer.attributes.survey_question_value.question_already_answered')) unless answers.empty?
    end
end
