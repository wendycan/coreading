class Article < ActiveRecord::Base
  belongs_to :user
  has_many :comments
  
  mount_uploader :pdf, PdfUploader

  self.per_page = 1
end
