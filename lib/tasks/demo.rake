namespace :db do
  desc "Resets the database and loads it from db/demo_seeds.rb"
  task demo_seed: :environment do
    load(Rails.root.join("db", "demo_seeds.rb"))
  end
end
