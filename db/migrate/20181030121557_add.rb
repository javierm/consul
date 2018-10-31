class Add < ActiveRecord::Migration
  def change
    add_column :survey_questions, :input_type, :string
    add_column :survey_question_answers, :comment, :string
  end
end
