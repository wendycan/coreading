class Annotation < ActiveRecord::Base
  validates :range, presence: true
  validates :quote, presence: true
  validates :tag, presence: true

  belongs_to :user
end
