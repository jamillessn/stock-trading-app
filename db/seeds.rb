admin = User.find_or_create_by!(email: 'test@admin.com') do |user|
  user.password = 'pass123'
  user.password_confirmation = 'pass123'
  user.admin = true
end

puts 'Admin user created!' if admin.persisted?

User.all.each do |user|
  user.update(default_balance: 10000)
end
