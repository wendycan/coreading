class Article < ActiveRecord::Base
  belongs_to :user
  has_many :comments
  
  validates :title, presence: true
  validates :pdf, presence: true
  validates :path_type, presence: true
  
  mount_uploader :pdf, PdfUploader

  self.per_page = 8
end
