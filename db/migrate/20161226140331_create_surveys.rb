class CreateSurveys < ActiveRecord::Migration
  def change
    create_table :surveys do |t|
      t.string :name
      t.string :code
      t.date :start
      t.date :end

      t.timestamps null: false
    end
  end
end
