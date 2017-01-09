class CreateSurveyQuestions < ActiveRecord::Migration
  def change
    create_table :survey_questions do |t|
      t.text :text
      t.integer :code
      t.integer :survey_id

      t.timestamps null: false
    end
  end
end
