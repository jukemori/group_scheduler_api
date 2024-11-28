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
require 'open-uri'
# Clean up existing records
Notification.destroy_all
CalendarInvitation.destroy_all
CalendarNote.destroy_all
Event.destroy_all
User.destroy_all
Calendar.destroy_all

# Create Users with photos
users = User.create!([
  { 
    name: 'John Doe', 
    nickname: 'john', 
    email: 'john@example.com', 
    password: 'password', 
    password_confirmation: 'password',
    uid: 'john@example.com',  
    provider: 'email',
    color: '#FF5733'  
  },
  { 
    name: 'Jane Doe', 
    nickname: 'jane', 
    email: 'jane@example.com', 
    password: 'password', 
    password_confirmation: 'password',
    uid: 'jane@example.com',  
    provider: 'email',
    color: '#33FF57' 
  }
])

# Attach photos to users
users.first.photo.attach(
  io: URI.open('https://www.blackpast.org/wp-content/uploads/mike-tyson-scaled.jpg'),
  filename: 'john.jpg'
)

users.second.photo.attach(
  io: URI.open('https://i.pinimg.com/originals/12/a1/c4/12a1c40426b011b5aaa8d54914067295.jpg'),
  filename: 'jane.jpg'
)

# Create Calendars
john_calendars = Calendar.create!([
  { name: 'Work Calendar', description: 'Calendar for work-related events' },
  { name: 'Personal Calendar', description: 'Calendar for personal events' },
  { name: 'Family Calendar', description: 'Calendar for family events' }
])

jane_calendars = Calendar.create!([
  { name: 'Study Calendar', description: 'Calendar for study schedule' },
  { name: 'Fitness Calendar', description: 'Calendar for workout routine' },
  { name: 'Social Calendar', description: 'Calendar for social events' }
])

# Link Users to Calendars
users.first.calendars << john_calendars
users.second.calendars << jane_calendars

# Create Events for John
john_calendars.each do |calendar|
  Event.create!([
    { 
      subject: 'Morning Meeting', 
      description: 'Daily standup', 
      start_time: '2024-11-01T09:00:00.000Z',
      end_time: '2024-11-01T10:00:00.000Z',
      user: users.first, 
      calendar: calendar 
    },
    { 
      subject: 'Project Review', 
      description: 'Monthly review', 
      start_time: '2024-11-15T14:00:00.000Z',
      end_time: '2024-11-15T16:00:00.000Z',
      user: users.first, 
      calendar: calendar 
    },
    { 
      subject: 'Team Building', 
      description: 'Team activity', 
      start_time: '2024-11-20T13:00:00.000Z',
      end_time: '2024-11-20T17:00:00.000Z',
      user: users.first, 
      calendar: calendar 
    }
  ])
end

# Create Events for Jane
jane_calendars.each do |calendar|
  Event.create!([
    { 
      subject: 'Study Session', 
      description: 'React basics', 
      start_time: '2024-11-05T10:00:00.000Z',
      end_time: '2024-11-05T12:00:00.000Z',
      user: users.second, 
      calendar: calendar 
    },
    { 
      subject: 'Gym Session', 
      description: 'Cardio day', 
      start_time: '2024-11-10T07:00:00.000Z',
      end_time: '2024-11-10T09:00:00.000Z',
      user: users.second, 
      calendar: calendar 
    },
    { 
      subject: 'Coffee Meetup', 
      description: 'Networking event', 
      start_time: '2024-11-25T15:00:00.000Z',
      end_time: '2024-11-25T16:30:00.000Z',
      user: users.second, 
      calendar: calendar 
    }
  ])
end

# Create Notes for John's calendars
john_calendars.each do |calendar|
  CalendarNote.create!([
    {
      content: "Important meeting notes for Q4 planning",
      user: users.first,
      calendar: calendar
    },
    {
      content: "Remember to prepare presentation slides",
      user: users.first,
      calendar: calendar
    }
  ])
end

# Create Notes for Jane's calendars
jane_calendars.each do |calendar|
  CalendarNote.create!([
    {
      content: "Study group meeting scheduled for next week",
      user: users.second,
      calendar: calendar
    },
    {
      content: "Don't forget to bring workout gear",
      user: users.second,
      calendar: calendar
    }
  ])
end

# Update the final output to include notes count
puts "Created #{User.count} users"
puts "Created #{Calendar.count} calendars"
puts "Created #{Event.count} events"
puts "Created #{CalendarNote.count} notes"
puts "Created #{Calendar.joins(:users).count} calendar-user associations"
