# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

require 'mysql'

class ApplicationController < ActionController::Base
  session :session_key => '_atompad_session_id', :secret => "304cbe51e2fddb5e298e6ff9ca0d1f6c"
  
  include AuthenticatedSystem

  before_filter :login_from_cookie, :globals

  def globals  
    #@name = ''
  end

end
