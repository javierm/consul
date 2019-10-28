class AddBudgetHeadingTranslations < ActiveRecord::Migration[5.1]
  def change
    create_table :budget_heading_translations do |t|
      t.integer :budget_heading_id, null: false
      t.string :locale, null: false
      t.timestamps null: false

      t.string :name

      t.index :budget_heading_id
      t.index :locale
    end
  end
end
