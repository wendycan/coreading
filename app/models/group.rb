class Group < ActiveRecord::Base
  has_many :usergroups
  has_many :users, :through => :usergroups
  has_many :articles

end
