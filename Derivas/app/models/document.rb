class Document < ActiveRecord::Base
  belongs_to :member
  belongs_to :group

  mount_uploader :address, DocumentUploader

  def file_path
    "/storage/uploads/document/address/#{id}/#{File.basename(address.url)}"
  end
end
