class CalendarNote < ApplicationRecord
  belongs_to :calendar
  belongs_to :user

  validates :content, presence: true
end
