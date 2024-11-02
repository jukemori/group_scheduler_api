class Calendar < ApplicationRecord
  has_and_belongs_to_many :users
  has_many :events, dependent: :destroy

  validates :name, presence: true
end
