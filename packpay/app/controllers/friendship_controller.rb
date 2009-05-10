class FriendshipController < ApplicationController
         
  def index
    redirect_to(:action => 'friends')
  end

  def friends
    @yours = current_user.friends
    @theirs = User.find(:all)    
  end 

  def add_friend                      
    @request = User.find(params[:id])
    current_user.become_friends_with(@request) 
    
    flash[:notice] = "Friend Added"
    render :action => 'index'    
  end  
    
  def remove_friend                     
    @request = User.find(params[:id])
    current_user.delete_friendship_with(@request)   

    flash[:notice] = "Friend Removed"
    render :action => 'index' 
  end    

end
