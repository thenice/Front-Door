class Token < ActiveRecord::Base
  
  SESSION_TIME = 30 # time to persist session, in minutes
  
  belongs_to :user
  before_create Proc.new { |token| token.set_value }
  validates_presence_of :user_id, :message => "Must be assoiciated with user"
  
  named_scope :expired, :conditions => ["valid_until < '#{Time.now.to_s(:db)}'"]
   
  def set_value
    self.value = UUID.new.generate
    self.valid_until = SESSION_TIME.minutes.from_now
  end
  
  def expired?
    not Time.now < self.valid_until
  end
  
  def active?
    not expired?
  end
  
  def Token.purge_expired_tokens
    Token.expired.each { |t| puts "."; t.destroy }
  end
  
end
