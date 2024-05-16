
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
  
p "Created #{user.email} as admin"

