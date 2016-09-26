class Member < ActiveRecord::Base
  belongs_to :user
  belongs_to :group

  validates :rol, presence: true
  # Relationship
  has_many :documents
end
