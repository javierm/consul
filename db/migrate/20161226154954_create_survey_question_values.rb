class CreateSurveyQuestionValues < ActiveRecord::Migration
  def change
    create_table :survey_question_values do |t|
      t.text :text
      t.integer :survey_question_id
      t.integer :order

      t.timestamps null: false
    end
  end
end
