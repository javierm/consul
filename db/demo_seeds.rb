require 'database_cleaner'
require 'csv'

csv_text = File.read(Rails.root.join('db', 'demo_users.csv'))
csv = CSV.parse(csv_text, :headers => false, col_sep: ';')


puts "Creating Users"

def create_user(email, username = Faker::Name.name)
  pwd = '12345678'
  puts "    #{username}"
  user = User.where(username: username, email: email).first_or_initialize
  if user.new_record?
    user.password_confirmation = pwd
    user.password = pwd
  end
  user.confirmed_at = Time.now
  user.terms_of_service = "1"
  user.save!
  user
end

csv.each_with_index do |row, i|
    puts row
    a = create_user(row.last, row.first)
    a.update(residence_verified_at: Time.now, confirmed_phone: Faker::PhoneNumber.phone_number, document_type: "1", verified_at: Time.now, document_number:i )
end

