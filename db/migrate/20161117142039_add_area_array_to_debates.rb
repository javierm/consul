class AddAreaArrayToDebates < ActiveRecord::Migration
  def change
    add_column :debates, :area, :string
  end
end
