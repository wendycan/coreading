class Comment < ActiveRecord::Base
  belongs_to :article
  belongs_to :user

  validates :ty, presence: true, inclusion: { in: ['as', 'is'] }
  varldates :si, presence: true
end
