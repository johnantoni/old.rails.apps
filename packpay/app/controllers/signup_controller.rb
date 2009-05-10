class SignupController < ApplicationController
  
  def index
    
  end
  
  def create
    return unless request.post?
    @signup = Signup.new(params[:signup])
    if @signup.save 
      flash[:notice] = "Yay!, thanks for that, we'll let you know when we go live."
    else
      flash[:notice] = "Uh oh, something went wrong."
    end 
    redirect_to :action => 'register'
  end
  
end
