class AddSurveyQuestionIdToSurveyQuestionAnswers < ActiveRecord::Migration
  def change
    add_column :survey_question_answers, :survey_question_id, :integer
  end
end
