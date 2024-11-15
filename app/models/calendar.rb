class Calendar < ApplicationRecord
  has_and_belongs_to_many :users
  has_many :events, dependent: :destroy
  has_many :calendar_invitations, dependent: :destroy
  has_many :invited_users, through: :calendar_invitations, source: :user

  validates :name, presence: true
end
