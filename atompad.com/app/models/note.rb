class Note < ActiveRecord::Base
  validates_presence_of :title, :body
  
  belongs_to :user

  acts_as_taggable
  acts_as_versioned
end
