class Chat < ActiveRecord::Base
  has_many :comments, :class_name => 'Comments'
  has_many :users, :through => :comments
       
  validates_presence_of :name  
end
