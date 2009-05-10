class GuideController < ApplicationController

  #handle news
  def news
    if logged_in?
      @user = User.find(self.current_user.id)
    end
  end                                        

  #legal terms
  def legal 
    #something
  end          

end
