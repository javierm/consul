class CreateSurveyQuestionAnswers < ActiveRecord::Migration
  def change
    create_table :survey_question_answers do |t|
      t.integer :survey_question_value_id
      t.integer :answered_survey_id
      
      t.timestamps null: false
    end
  end
end
