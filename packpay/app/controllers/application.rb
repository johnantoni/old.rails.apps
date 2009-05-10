# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

#require 'rubygems' 
require 'mysql'
require 'tzinfo'
require 'mini_magick'

class ApplicationController < ActionController::Base
  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => '_dwm_session_id', :secret => '6a009914195eef6ffc49ac7c9800ab24'

  include AuthenticatedSystem
  
  before_filter :login_from_cookie, :meta_profile

  def meta_profile
    @county = ["Avon", "Bedfordshire", "Berkshire", "Buckinghamshire",
      "Cambridgeshire", "Cheshire", "Cleveland", "Cornwall", "Cumbria",
      "Derbyshire", "Devon", "Dorset", "Durham", "Essex", 
      "Gloucestershire", "Hampshire", "Hereford & Worcester", 
      "Hertfordshire", "Humberside", "Kent", "Lancashire",
      "Leicestershire", "Lincolnshire", "London", "Manchester",
      "Merseyside", "Norfolk", "Northamptonshire", "Northumberland",
      "Nottinghamshire", "Oxfordshire", "Shropshire", "Somerset", 
      "Staffordshire", "Suffolk", "Surrey", "Sussex", "Tyne & Wear", 
      "Warwickshire", "West Midlands", "Wiltshire", "Yorkshire"]
    @page = "Home page"

    @categories = Categories.find(:all, :order => 'name')    
  end
    
end
