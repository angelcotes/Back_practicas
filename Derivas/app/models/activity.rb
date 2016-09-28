class Activity < ActiveRecord::Base
  # Relationship
  belongs_to :course
  has_many :groups

  validates :name_activity, :range, :latitude, :longitude, :start_date, :finish_date, :duration, presence: true
end
