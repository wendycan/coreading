class Article < ActiveRecord::Base
  has_many :comments
  self.per_page = 1
end
