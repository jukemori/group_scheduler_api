# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Clear existing data
User.destroy_all
Calendar.destroy_all
Event.destroy_all

# Create Users
user1 = User.create!(email: 'user1@example.com', password: 'password123', name: 'User One', nickname: 'U1', color: 'blue')
user2 = User.create!(email: 'user2@example.com', password: 'password123', name: 'User Two', nickname: 'U2', color: 'red')

# Create Calendars
calendar1 = Calendar.create!(name: 'Work Calendar')
calendar2 = Calendar.create!(name: 'Personal Calendar')

# Create Events
event1 = Event.create!(
  calendar_id: calendar1.id,
  user_id: user1.id,
  subject: 'Team Meeting',
  description: 'Weekly team sync',
  start_time: '2024-09-01T09:00:00Z',
  end_time: '2024-09-01T10:00:00Z',
  start_timezone: 'UTC',
  end_timezone: 'UTC',
  is_all_day: false,
  is_block: true,
  is_readonly: false,
  location: 'Conference Room',
  recurrence_rule: 'FREQ=WEEKLY',
  recurrence_exception: '2024-09-15T09:00:00Z',
  recurrence_id: 1,
  following_id: 2
)

event2 = Event.create!(
  calendar_id: calendar2.id,
  user_id: user2.id,
  subject: 'Birthday Party',
  description: 'Celebrate with friends',
  start_time: '2024-09-05T18:00:00Z',
  end_time: '2024-09-05T22:00:00Z',
  start_timezone: 'UTC',
  end_timezone: 'UTC',
  is_all_day: true,
  is_block: false,
  is_readonly: false,
  location: 'Home',
  recurrence_rule: '',
  recurrence_exception: '',
  recurrence_id: nil,
  following_id: nil
)

# Output record counts
puts "Users count: #{User.count}"
puts "Calendars count: #{Calendar.count}"
puts "Events count: #{Event.count}"
