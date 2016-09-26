class Activity < ActiveRecord::Base
  belongs_to :course

  validates :name_activity, :range, :latitude, :longitude, :start_date, :finish_date, :duration, presence: true
  # Relationship
  has_many :groups
end
