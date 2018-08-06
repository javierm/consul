class AddGeozoneResidenceToUsers < ActiveRecord::Migration
  def change
    add_column :users, :geozone_residence, :boolean, default: nil
  end
end
