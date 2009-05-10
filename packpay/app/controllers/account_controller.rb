class AccountController < ApplicationController
  authenticated_commands # for easymailer

  def index
    @images = Image.find(:all, :conditions => ["parent_id is NULL"])
    @comments = Comment.find(:all)
    @chats = Chat.find(:all)
  end

  def login
    return unless request.post?
    @login = params[:login] #add this variable to remember login entered if wrong    
    self.current_user = User.authenticate(params[:login], params[:password])
    if logged_in?
      if params[:remember_me] == "1"
        self.current_user.remember_me
        cookies[:auth_token] = { 
          :value => self.current_user.remember_token , 
          :expires => self.current_user.remember_token_expires_at 
          }
      end
      redirect_back_or_default(:controller => '/account', :action => 'index')
      flash[:notice] = "Welcome Back!"
    else 
      flash[:notice] = "Sorry, wrong password or email address"
      render :action => 'login'
    end
  end

  def signup
    return unless request.post?

    begin
      #create user
      @user = User.new(params[:user])
      @user.save!
      self.current_user = @user #current_user becomes new user record 

      #create profile
      @profile = Profile.new(params[:profile])
      @profile.user_id = self.current_user.id #assign profile to user
      @profile.save!
    
      #send registration email
      UserMailer.deliver_registration(self.current_user)
    
      #redirect to homepage if all ok
      redirect_back_or_default(:controller => '/account', :action => 'index')
      flash[:notice] = "Thank you for signing up!"
      
    rescue ActiveRecord::RecordInvalid
      #if not, redirect to signup page with message
      flash[:notice] = "Sorry, something went wrong"
      render :action => 'signup'
    end
  end
  
  def logout
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    flash[:notice] = "You have been successfully logged out."
    redirect_back_or_default(:controller => '/account', :action => 'index')
  end
  
  #update the user table
  def update
    @user = User.find(self.current_user.profile)
    if @profile.update_attributes(params[:profile])
      flash[:notice] = 'Your profile has been updated.'
      redirect_to :action => 'profile'
    else
      render :action => 'profile'
    end    
  end  

  def password
    return unless request.post?
    if User.authenticate(current_user.login, params[:old_password])
      if (params[:password] == params[:password_confirmation])
        current_user.password_confirmation = params[:password_confirmation]
        current_user.password = params[:password]
        flash[:notice] = current_user.save ?
              "Password changed" :
              "Password not changed"
            redirect_to :action => 'profile'
      else
        flash[:notice] = "Password mismatch" 
        @old_password = params[:old_password]
      end
    else
      flash[:notice] = "Wrong password" 
    end
  end

  def forgot_password
    return unless request.post?
    if @user = User.find(:first, :conditions => [ "login = ?", params[:email] ])
      @user.forgot_password #method in user model
      @user.save #changed from .update
      UserMailer.deliver_pw_reset_link(@user)
      flash[:notice] = "Password reset link has been emailed to you at " + @user.login
      redirect_to :controller => '/account', :action => 'index'
    else
      flash.now[:notice] = "Could not find a user with the given email address."
    end
  end 

  def reset_password
    @user = User.find(:first, :conditions => [ "pw_reset_code = ?", params[:id] ] ) rescue nil
    unless @user
      render(:text => "Not found", :status => 404)
      return
    end
    return unless request.post?
    if @user.update_attributes(params[:user])
      @user.reset_password #method in model
      flash[:notice] = "Password successfully reset."
      redirect_to :controller => '/account', :action => 'index'
    end
  end

  #show profile
  def profile
    @profile = Profile.find(self.current_user.profile.id)
  end  

  #update profile
  def profile_update
    @profile = Profile.find(params[:id])
    if @profile.update_attributes(params[:profile])
      flash[:notice] = 'Your profile has been updated.'
      redirect_to :action => 'profile'
    else
      flash[:notice] = "Sorry, something went wrong"
      render :action => 'profile'
    end    
  end  
    
  def details
    @user = User.find(params[:id])
  end
      
end
