class AddLegislatorIdToComments < ActiveRecord::Migration[5.1]
  def change
    add_column :comments, :legislator_id, :integer
  end
end
