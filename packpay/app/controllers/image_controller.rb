class ImageController < ApplicationController

  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @images = Image.paginate :page => params[:page]
  end

  def show
    @image = Image.find(params[:id])
    if @image.user_id != self.current_user.id
      redirect_to :action => 'list'
    end     
  end

  def new
    @image = Image.new
  end

  def create
    @image = Image.new(params[:image])
    @image.user_id = self.current_user.id
    if @image.save
      flash[:notice] = 'Photo was successfully created.'
      redirect_to :action => 'list'
    else
      flash[:notice] = 'Something awful just happend!'
      render :action => 'new'
    end
  end

  def edit
    @image = Image.find(params[:id])
  end

  def update
    @image = Image.find(params[:id])
    if @photo.update_attributes(params[:image])
      flash[:notice] = 'Photo was successfully updated.'
      redirect_to :action => 'show', :id => @image
    else
      flash[:notice] = 'Something awful just happend!'
      render :action => 'edit'
    end
  end

  def destroy
    Image.find(params[:id]).destroy
    redirect_to :action => 'list'
  end

  def set
    #set as profile image           
    @image = Image.find(params[:id])
    
    if not self.current_user.default_image.blank?
      @user = Image.find(self.current_user.default_image)
      @user.default = false
      @user.save
    end
    
    @image.default = true
    @image.save
    redirect_to :controller => 'account', :action => 'profile'
  end  

end
