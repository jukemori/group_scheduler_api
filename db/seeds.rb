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
      start_time: Time.current.beginning_of_month + 1.day + 9.hours,
      end_time: Time.current.beginning_of_month + 1.day + 10.hours,
      user: users.first, 
      calendar: calendar 
    },
    { 
      subject: 'Project Review', 
      description: 'Monthly review', 
      start_time: Time.current.beginning_of_month + 15.days + 14.hours,
      end_time: Time.current.beginning_of_month + 15.days + 16.hours,
      user: users.first, 
      calendar: calendar 
    },
    { 
      subject: 'Team Building', 
      description: 'Team activity', 
      start_time: Time.current.beginning_of_month + 20.days + 13.hours,
      end_time: Time.current.beginning_of_month + 20.days + 17.hours,
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
      start_time: Time.current.beginning_of_month + 5.days + 10.hours,
      end_time: Time.current.beginning_of_month + 5.days + 12.hours,
      user: users.second, 
      calendar: calendar 
    },
    { 
      subject: 'Gym Session', 
      description: 'Cardio day', 
      start_time: Time.current.beginning_of_month + 10.days + 7.hours,
      end_time: Time.current.beginning_of_month + 10.days + 9.hours,
      user: users.second, 
      calendar: calendar 
    },
    { 
      subject: 'Coffee Meetup', 
      description: 'Networking event', 
      start_time: Time.current.beginning_of_month + 25.days + 15.hours,
      end_time: Time.current.beginning_of_month + 25.days + 16.hours + 30.minutes,
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
