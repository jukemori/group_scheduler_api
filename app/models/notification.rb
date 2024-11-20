class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :calendar
  belongs_to :event, optional: true
  belongs_to :calendar_note, optional: true
  belongs_to :calendar_invitation, optional: true

  validates :action, presence: true
  validates :message, presence: true
end
