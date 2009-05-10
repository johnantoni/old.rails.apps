class Comment < ActiveRecord::Base
  belongs_to :chat, :class_name => 'Chat'
  belongs_to :user, :class_name => 'User'

  validates_presence_of :comment    
end
