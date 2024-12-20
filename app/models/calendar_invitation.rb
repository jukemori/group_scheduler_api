class CalendarInvitation < ApplicationRecord
  belongs_to :calendar
  belongs_to :user
  has_many :notifications, dependent: :nullify

  enum status: { pending: 0, accepted: 1, rejected: 2 }
  
  validates :calendar_id, uniqueness: { scope: :user_id }
end
