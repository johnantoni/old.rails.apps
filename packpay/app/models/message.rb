class Message < ActiveRecord::Base

  attr_accessor :recipient
  
  belongs_to :sender,
             :class_name => "User",
             :foreign_key => "sender_id"
                     
  belongs_to :receiver,
             :class_name => "User",
             :foreign_key => "receiver_id"

  validates_presence_of :recipient, 
                        :subject,
                        :body
                        
  validates_length_of :body, 
                      :minimum => 25, 
                      :message => "is too short.  The mimum length is %d characters. Please don't spam."
                      
  validates_length_of :body, 
                      :maximum => 250, 
                      :message => "is too long.  No one wants to read that.  The maximum length is %d characters"
    
  # Returns user.login for the sender
  def sender_name
    User.find(sender_id).login || ""
  end
  
  # Returns user.login for the receiver
  def receiver_name
    User.find(receiver_id).login || ""
  end
  
  # Assigns the recipient to the receiver_id.
  # I'm sure there is a better way.  Please let me know.
  def before_create
    u = User.find_by_login(recipient)
    self.receiver_id = u.id
  end
  
  # Validates that a user has entered a valid user.login name for the message recipient
  def validate_on_create
    u = User.find_by_login(recipient)
    errors.add(:recipient, "is not a valid user.") if u.nil?
  end        
end
