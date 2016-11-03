class User < ActiveRecord::Base
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
          :recoverable, :validatable
  include DeviseTokenAuth::Concerns::User

  validates :first_name, :last_name, presence: true

  # Relationship
  has_many :courses
  has_many :activities, through: :courses
  has_many :students, through: :courses
  has_many :members
end
