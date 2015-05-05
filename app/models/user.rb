class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :comments
  has_many :annotations
  has_many :articles
  has_many :usergroups
  has_many :groups, :through => :usergroups

  before_create :generate_authentication_token

  def generate_authentication_token
    loop do
      self.authentication_token = SecureRandom.hex 20
      break unless self.class.exists?(authentication_token: authentication_token)
    end
  end

end
