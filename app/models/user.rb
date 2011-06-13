class User < ActiveRecord::Base
  
  attr_accessible :username, :password, :password_confirmation
  attr_accessor :password
  
  before_save :encrypt_password
  before_create :setup_new_user

  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
  validates_presence_of :username
  validates_uniqueness_of :username
  
  has_many :tokens
  
  def self.authenticate(_username, password)
    user = find_by_username(_username)
    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      user.logins = user.logins+=1
      user.last_login_at = DateTime.now
      user.save
      token = Token.create!(:user => user)
      token.value
    else
      nil
    end
  end
  
  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end
  
  def setup_new_user
    self.logins = 0
  end
  
  
end
