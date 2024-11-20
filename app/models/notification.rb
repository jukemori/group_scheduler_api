class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :calendar
  belongs_to :event, optional: true
  belongs_to :calendar_note, optional: true
  belongs_to :calendar_invitation, optional: true

  validates :action, presence: true
  validates :message, presence: true

  scope :unread, -> { where(read: false) }
  scope :read, -> { where(read: true) }
  scope :recent, -> { order(created_at: :desc) }

  def mark_as_read!
    update!(read: true)
  end

  def mark_as_unread!
    update!(read: false)
  end
end
