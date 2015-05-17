class Article < ActiveRecord::Base
  belongs_to :user
  belongs_to :group
  
  has_many :comments
  has_many :annotations
  
  validates :title, presence: true
  # validates :pdf, presence: true
  validates :path_type, presence: true
  
  mount_uploader :pdf, PdfUploader

  self.per_page = 8
end
