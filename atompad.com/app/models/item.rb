class Item < ActiveRecord::Base
  validates_presence_of :body
  
  belongs_to :list

#  acts_as_list :scope => :list
end
