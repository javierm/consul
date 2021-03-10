class AddPostalCodeAndResultToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :postal_code, :string
    add_column :users, :services_results, :jsonb
  end
end
