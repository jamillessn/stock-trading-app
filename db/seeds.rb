# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Create an admin user
admin = User.create!(
  email: 'test@admin.com',
  password: 'pass123',
  password_confirmation: 'pass123',
  admin: true,
  approved: true
)

puts 'Admin user created!' if admin.persisted?

User.all.each do |user|
  user.update(default_balance: 10000)
end
