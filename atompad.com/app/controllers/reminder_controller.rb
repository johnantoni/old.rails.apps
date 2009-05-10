class ReminderController < ApplicationController
  before_filter :login_required
  #in_place_edit_for :item, :title

  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @reminders = Reminder.find(:all)
  end

  def show
    @reminder = Reminder.find(params[:id])
    # check user only viewing own stuff
    if @reminder.user_id != self.current_user.id
      redirect_to :action => 'list'
    end 
  end

  def new
    @reminder = Reminder.new
  end

  def create
    return unless request.post?    
    @reminder = Reminder.new(params[:reminder])
    if @reminder.save
      flash[:notice] = 'Reminder was successfully created.'
    else
      flash[:notice] = 'Something went wrong.'
    end
  end

  def edit
    @reminder = Reminder.find(params[:id])
  end

  def update
    @reminder = Reminder.find(params[:id])
    if @reminder.update_attributes(params[:reminder])
      flash[:notice] = 'Reminder was successfully updated.'
      redirect_to :action => 'list'
    else
      render :action => 'edit'
    end
  end

  def add_reminder
    @reminder = Reminder.create(params[:reminder])
    
    @reminders = Reminder.find(:all)
    render :partial => 'reminders', :id => @reminders
  end

  def destroy
    Reminder.find(params[:id]).destroy
    
    @reminders = Reminder.find(:all)
    render :partial => 'reminders', :id => @reminders
  end

  def set_reminder_title
    @reminder = Reminder.find(params[:id])
    @reminder.update_attributes(:title => params[:value])
    
    @reminder = Reminder.find(params[:id])
    render :update do |page|
      page.replace 'item_' << params[:id], :partial => 'reminder', :object => @reminder
    end
  end
end
