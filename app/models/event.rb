class Event < ApplicationRecord
  belongs_to :user
  belongs_to :calendar
  has_many :notifications, dependent: :nullify
end
