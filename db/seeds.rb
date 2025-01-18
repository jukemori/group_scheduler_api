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
# Clean up existing records in the correct order
Notification.destroy_all
CalendarInvitation.destroy_all
CalendarNote.destroy_all
Event.destroy_all
Calendar.destroy_all
User.destroy_all

# Define colors array
COLORS = [
  '#FF0000', '#FFA500', '#00BFFF', '#00FF00', '#FF69B4'
]

# Define realistic user data
USER_DATA = [
  { name: 'Michael Chen', gender: 'male', email: 'michael@example.com' },
  { name: 'Emily Johnson', gender: 'female', email: 'emily@example.com' },
  { name: 'Sarah Martinez', gender: 'female', email: 'sarah@example.com' },
  { name: 'David Wilson', gender: 'male', email: 'david@example.com' },
  { name: 'Jessica Kim', gender: 'female', email: 'jessica@example.com' },
  { name: 'James Rodriguez', gender: 'male', email: 'james@example.com' },
  { name: 'Aisha Patel', gender: 'female', email: 'aisha@example.com' },
  { name: 'Lucas Silva', gender: 'male', email: 'lucas@example.com' },
  { name: 'Sofia Garcia', gender: 'female', email: 'sofia@example.com' },
  { name: 'Alexander Lee', gender: 'male', email: 'alex@example.com' },
  { name: 'Emma Thompson', gender: 'female', email: 'emma@example.com' },
  { name: 'Omar Hassan', gender: 'male', email: 'omar@example.com' },
  { name: 'Priya Sharma', gender: 'female', email: 'priya@example.com' },
  { name: 'Thomas Anderson', gender: 'male', email: 'thomas@example.com' },
  { name: 'Mei Wong', gender: 'female', email: 'mei@example.com' }
]

# First create all users
users = []
USER_DATA.each do |data|
  user = User.create!(
    name: data[:name],
    nickname: data[:name].split(' ').first,
    email: data[:email],
    password: 'password',
    password_confirmation: 'password',
    provider: 'email',
    color: COLORS.sample
  )
  
  # Generate and attach random person photo
  age = rand(25..55)
  ethnicity = ['asian', 'white', 'latino', 'black'].sample
  
  url = "https://this-person-does-not-exist.com/new?gender=#{data[:gender]}&age=#{age}&etnic=#{ethnicity}"
  json = URI.open(url).read
  src = JSON.parse(json)['src']
  photo_url = "https://this-person-does-not-exist.com#{src}"
  
  file = URI.open(photo_url)
  user.photo.attach(io: file, filename: "user_#{data[:email]}.png", content_type: 'image/png')
  user.save
  
  users << user
end

# Create themed calendars with the first user as main user
main_user = users.first
calendar_data = [
  {
    name: "💪 Fitness",
    description: "Track workouts and fitness activities",
    members: users.sample(8)
  },
  {
    name: "📚 Study Group",
    description: "Academic planning and study sessions",
    members: users.sample(8)
  },
  {
    name: "👨‍👩‍👧‍👦 Family Events",
    description: "Family gatherings and important dates",
    members: users.sample(8)
  }
]

# Create calendars and add members
calendar_data.each do |data|
  calendar = Calendar.create!(
    name: data[:name],
    description: data[:description],
    creator_id: main_user.id
  )

  # Add main user and selected members to the calendar
  ([main_user] + data[:members]).uniq.each do |user|
    user.calendars << calendar unless user.calendars.include?(calendar)
    
    # Create invitation and notification for each member (except main user)
    unless user == main_user
      invitation = CalendarInvitation.create!(
        calendar: calendar,
        user: user,
        status: :accepted
      )

      Notification.create!(
        user: user,
        calendar: calendar,
        calendar_invitation: invitation,
        action: invitation.status,
        notification_type: 'invitation',
        message: "#{user.nickname} #{invitation.status} invitation to #{calendar.name}"
      )
    end
  end

  # Create events specific to each calendar theme
  members_pool = ([main_user] + data[:members]).uniq
  
  # Calculate spread for dates and times
  days_in_month = (DateTime.current.end_of_month - DateTime.current.beginning_of_month).to_i
  day_spread = days_in_month / 15.0  # Spread 15 events across the month
  
  20.times do |i|
    # More evenly distribute event creation among all members
    creator = members_pool[i % members_pool.length]
    
    # Ensure each member creates at least one event by forcing creator for first N events
    # where N is the number of members
    if i < members_pool.length
      creator = members_pool[i]
    end

    # Spread events throughout the month
    base_day = DateTime.current.beginning_of_month + (i * day_spread).days
    day = base_day + rand(-2..2).days  # Add some randomness within ±2 days
    
    # Spread events throughout the day (between 7 AM and 8 PM)
    start_hour = 7 + (i % 12)  # Spread across different hours
    start_hour = start_hour + rand(-1..1)  # Add slight randomness to hour
    start_hour = [[start_hour, 7].max, 20].min  # Keep between 7 AM and 8 PM
    
    # Avoid weekends
    while day.wday == 0 || day.wday == 6
      day += 1.day
    end
    
    event_subject = case calendar.name
    when "💪 Fitness"
      [
        "Group Workout", "Running Session", "Yoga Class", "Weight Training", "HIIT Session",
        "Pilates Class", "Swimming Practice", "CrossFit Training", "Zumba Dance",
        "Boxing Class", "Spinning Session", "Core Workout", "Stretching Session",
        "Circuit Training", "Mountain Biking", "Rock Climbing", "Kickboxing",
        "Dance Fitness", "Martial Arts", "Basketball Game", "Tennis Match",
        "Soccer Practice", "Meditation Session", "Functional Training", "TRX Class"
      ].sample
    when "📚 Study Group"
      [
        "Group Study", "Project Meeting", "Exam Prep", "Research Discussion", "Tutorial Session",
        "Paper Review", "Presentation Practice", "Lab Meeting", "Coding Workshop",
        "Literature Review", "Thesis Discussion", "Mock Interview", "Case Study Analysis",
        "Language Exchange", "Problem Solving Session", "Math Study Group",
        "Science Experiment", "Writing Workshop", "Debate Practice", "Study Skills Workshop",
        "Peer Review Session", "Research Methodology", "Statistics Workshop", "Book Club",
        "Historical Analysis"
      ].sample
    when "👨‍👩‍👧‍👦 Family Events"
      [
        "Family Dinner", "Birthday Party", "Weekend Getaway", "Movie Night", "Game Night",
        "Barbecue Party", "Holiday Celebration", "Family Reunion", "Picnic in the Park",
        "Cooking Together", "Family Photos", "Sunday Brunch", "Family Workshop",
        "Garden Party", "Family Sports Day", "Museum Visit", "Zoo Trip",
        "Baking Session", "Arts & Crafts Time", "Board Game Tournament",
        "Family Beach Day", "Hiking Adventure", "Pizza Making Night", "Story Time",
        "Family Volunteering"
      ].sample
    end
    
    event_time = day + start_hour.hours
    event = Event.create!(
      subject: event_subject,
      description: Faker::Company.bs,
      start_time: event_time,
      end_time: event_time + rand(1..3).hours,
      user: creator,
      calendar: calendar
    )

    # Create notification with a random time using minutes and hours
    max_time = [event_time, Time.current - 1.hour].min
    random_hours = rand(0..48)  # Random hours up to 2 days
    random_minutes = rand(0..59)  # Random minutes within the hour
    notification_time = max_time - random_hours.hours - random_minutes.minutes
    
    Notification.create!(
      user: creator,
      calendar: calendar,
      event: event,
      action: 'created',
      notification_type: 'event',
      message: "#{creator.nickname} created event: #{event.subject} in #{calendar.name}",
      created_at: notification_time,
      updated_at: notification_time
    )
  end

  # Create themed notes with more variety and different timestamps
  ([main_user] + data[:members]).sample(rand(3..5)).each do |user|
    note_content = case calendar.name
    when "💪 Fitness"
      [
        "Remember to bring water and towels!", 
        "New workout plan uploaded - check the docs",
        "Great progress everyone! Keep it up!",
        "Updated schedule for next month",
        "Equipment maintenance scheduled",
        "New protein shake recipe shared",
        "Track your progress in the spreadsheet"
      ].sample
    when "📚 Study Group"
      [
        "Don't forget to review chapter 5",
        "Shared study materials in drive - check folder",
        "Quiz preparation guidelines updated",
        "New research papers added",
        "Meeting minutes from last session",
        "Updated assignment deadlines",
        "Resource links for extra practice"
      ].sample
    when "👨‍👩‍👧‍👦 Family Events"
      [
        "Please RSVP by next Friday",
        "Bringing homemade dessert!",
        "Don't forget to bring gifts and cards",
        "Updated venue information",
        "Dietary restrictions list updated",
        "Photo sharing instructions",
        "Carpool arrangements posted"
      ].sample
    end

    # Create multiple notes per user with different timestamps
    rand(1..3).times do
      created_at = rand(1.week.ago..Time.current)
      note = CalendarNote.create!(
        content: note_content,
        user: user,
        calendar: calendar,
        created_at: created_at,
        updated_at: created_at
      )

      # Create notification with a random time using minutes and hours
      max_time = [created_at, Time.current - 1.hour].min
      random_hours = rand(0..48)  # Random hours up to 2 days
      random_minutes = rand(0..59)  # Random minutes within the hour
      notification_time = max_time - random_hours.hours - random_minutes.minutes
      
      Notification.create!(
        user: user,
        calendar: calendar,
        calendar_note: note,
        action: 'created',
        notification_type: 'note',
        message: "#{user.nickname} added note: #{note.content.truncate(30)} in #{calendar.name}",
        created_at: notification_time,
        updated_at: notification_time
      )
    end
  end
end

# Print summary
puts "Created #{User.count} users"
puts "Created #{Calendar.count} calendars"
puts "Created #{Event.count} events"
puts "Created #{CalendarNote.count} notes"
puts "Created #{Notification.count} notifications"
puts "Created #{Calendar.joins(:users).count} calendar-user associations"
