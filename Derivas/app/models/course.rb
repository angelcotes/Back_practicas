class Course < ActiveRecord::Base
  belongs_to :user

  validates :name, :period, presence: true

  # Relationship
  has_many :students
  has_many :users, through: :students
  has_many :activities
end
