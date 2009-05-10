class BownzController < ApplicationController
  
  def index  
  end

  def create
    return unless request.post?
    
    begin
      @chat = Chat.new(params[:chat])
      @chat.save!
    
      @comment = Comment.create(:user_id => self.current_user.id, :chat_id => @chat.id)
      @comment.update_attributes(params[:comment])
      @comment.save!
      
      flash[:notice] = 'Bownz was successfully created.'
      redirect_to :controller => 'account', :action => 'index'

    rescue ActiveRecord::RecordInvalid
      flash[:notice] = 'Uh oh, Something awful just happend!'
      render :action => 'create'
    end
  end

  def show
    @chat = Chat.find(params[:id])
    @category = Categories.find(:first, :conditions => ["id = ?", @chat.subject]) 
    
    @comments = Comment.find(:all, :conditions => ["chat_id = ?", params[:id]])
  end

  def comment
    return unless request.post?

    begin
      @comment = Comment.create(:user_id => self.current_user.id, :chat_id => params[:id])
      @comment.update_attributes(params[:comment])
      @comment.save!

      flash[:notice] = 'Comment was successfully added.'
      redirect_to :controller => 'bownz', :action => 'show', :id => params[:id]

    rescue ActiveRecord::RecordInvalid
      flash[:notice] = 'Uh oh, Something awful just happend!'
      #render :action => 'create'
    end
  end
  
  def sort
    @category = Categories.find(:first, :conditions => ["id = ?", params[:id]]) 
    @chats = Chat.find(:all, :conditions => ["subject = ?", params[:id]])    
  end
  
  def search
    @chats = Chat.find(:all, :conditions => ["name like ?", '%'+params[:search]+'%']) 
    @search = params[:search]
  end
  
end
