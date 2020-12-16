class CreateLegislators < ActiveRecord::Migration[5.1]
  def change
    create_table :legislators do |t|
      t.belongs_to :user, index: true, foreign_key: true
      t.string :description
    end
  end
end
