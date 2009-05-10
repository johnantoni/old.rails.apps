class List < ActiveRecord::Base
  validates_presence_of :title

  belongs_to :user
  
  has_many :items, :order => "position"
end
