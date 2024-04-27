
Rails.cache.clear

# Create an admin user
User.destroy_all

user = User.new(
    email: 'testadmin@gmail.com', 
    password: 'admin123', 
    password_confirmation: 'admin123',
    admin: true,
    approved: true,
    first_name: 'Admin'
  )
  user.skip_confirmation!
  user.save!
  
p "Created #{User.count} as admin"

User.all.each do |user|
  user.update(default_balance: 10000)
end
