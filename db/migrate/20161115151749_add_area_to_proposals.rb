class AddAreaToProposals < ActiveRecord::Migration
  def change
    add_column :proposals, :area, :string
    add_column :proposals, :area_revised_at, :datetime
  end
end
