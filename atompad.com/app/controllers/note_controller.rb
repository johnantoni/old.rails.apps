class NoteController < ApplicationController
  before_filter :login_required
  layout 'application', :except => [:version]
  
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @notes = Note.find(:all)
  end

  def show
    @note = Note.find(params[:id])
    # check user only viewing own stuff
    if @note.user_id != self.current_user.id
      redirect_to :action => 'list'
    end 
  end

  def new
    @note = Note.new
    @note.create_versioned_table
  end

  def create
    return unless request.post?
    @note = Note.new(params[:note])
    @note.user_id = self.current_user.id
    if @note.save 
      flash[:notice] = 'Note was successfully created.'
    end
    redirect_to :action => 'list'
  end

  def edit
    @note = Note.find(params[:id])
  end

  def update
    @note = Note.find(params[:id])
    if @note.update_attributes(params[:note])
      flash[:notice] = 'Note was successfully updated.'
      redirect_to :action => 'show', :id => @note
    else
      render :action => 'edit'
    end
  end

  def destroy
    Note.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  
  def revert_to_version 
    @note = Note.find(params[:note_id]) 
    @note.revert_to! params[:version_id] 
    redirect_to :action => 'show', :id => @note
  end  
  
  def version
    @version = Note.find_version(params[:id], params[:ver]) 
  end
  
end
