class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  extend Devise::Models
  include DeviseTokenAuth::Concerns::User
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  before_create :skip_confirmation!       
  
  has_and_belongs_to_many :calendars
  has_many :events, foreign_key: 'user_id'

  # validates :color, format: { with: /\A#(?:[0-9a-fA-F]{3}){1,2}\z/, message: "must be a valid hex color code" }
  validates :name, presence: true
  validates :nickname, presence: true, uniqueness: true
end
