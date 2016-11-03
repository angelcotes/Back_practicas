class Student < ActiveRecord::Base
  belongs_to :course
  belongs_to :user
  has_many :activities, through: :course
end
