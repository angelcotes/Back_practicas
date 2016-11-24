class Document < ActiveRecord::Base
  belongs_to :member
  belongs_to :group

  mount_uploader :address, DocumentUploader
end