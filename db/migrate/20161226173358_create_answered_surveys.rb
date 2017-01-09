class CreateAnsweredSurveys < ActiveRecord::Migration
  def change
    create_table :answered_surveys do |t|
      t.integer :user_id
      
      t.timestamps null: false
    end
  end
end
