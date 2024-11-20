class CalendarNote < ApplicationRecord
  belongs_to :calendar
  belongs_to :user
  has_many :notifications, dependent: :nullify

  validates :content, presence: true
end
