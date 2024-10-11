# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# db/seeds.rb

# Clean up existing records
Event.destroy_all
User.destroy_all
Calendar.destroy_all

# Create Users
users = User.create!([
  { 
    name: 'John Doe', 
    nickname: 'john', 
    email: 'john@example.com', 
    password: 'password', 
    password_confirmation: 'password',
    uid: 'john@example.com',  
    provider: 'email'         
  },
  { 
    name: 'Jane Doe', 
    nickname: 'jane', 
    email: 'jane@example.com', 
    password: 'password', 
    password_confirmation: 'password',
    uid: 'jane@example.com',  
    provider: 'email'         
  }
])

# Create Calendars
calendars = Calendar.create!([
  { name: 'Work Calendar', description: 'Calendar for work-related events' },
  { name: 'Personal Calendar', description: 'Calendar for personal events' }
])

# Link Users to Calendars
users.each do |user|
  user.calendars << calendars.sample
end

# Create Events
Event.create!([
  { subject: 'Meeting with client', description: 'Discuss project requirements', start_time: '2024-09-05 09:00:00', end_time: '2024-09-05 10:00:00', user: users.first, calendar: calendars.first },
  { subject: 'Lunch with Jane', description: 'Lunch at favorite restaurant', start_time: '2024-09-06 12:00:00', end_time: '2024-09-06 13:00:00', user: users.second, calendar: calendars.second }
])

# Output counts of created records
puts "Created #{User.count} users"
puts "Created #{Calendar.count} calendars"
puts "Created #{Event.count} events"
puts "Created #{Calendar.joins(:users).count} calendar-user associations"
