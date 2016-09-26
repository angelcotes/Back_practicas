class Group < ActiveRecord::Base
  belongs_to :activity

  validates :name_group, presence: true
  # Relationship
  has_many :members
  has_many :users, through: :members
  has_many :documents
end
