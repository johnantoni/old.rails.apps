class ListController < ApplicationController
  before_filter :login_required

  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @lists = List.find(:all)
  end

  def show
    @list = List.find(params[:id])
    # check user only viewing own stuff
    if @list.user_id != self.current_user.id
      redirect_to :action => 'list'
    end 
  end

  def new
    @list = List.new
  end

  def create
    return unless request.post?
    @list = List.new(params[:list])
    @list.user_id = self.current_user.id
    if @list.save
      flash[:notice] = 'List was successfully created.'
    end
    redirect_to :action => 'list'
  end

  def edit
    @list = List.find(params[:id])
  end

  def update
    @list = List.find(params[:id])
    if @list.update_attributes(params[:list])
      flash[:notice] = 'List was successfully updated.'
      redirect_to :action => 'list', :id => @list
    else
      render :action => 'edit'
    end
  end

  def destroy
    List.find(params[:id]).destroy
    redirect_to :action => 'list'
  end

  def add_item
    return unless request.post?    
    @list = List.find(params[:id])   
    #use create! when creating ajax add-record calls
    #the ! allows you to evalute unsaved records with .save
    @list.items.create!(params[:item])  
    #if @list.items.save 
      render :partial => 'items', :layout => false
    #end
  end

  def update_positions
    params[:item_list].each_with_index do |id, position|
      ListItem.update(id, :position => position+1)
    end
    render :nothing => true
  end
  
  def destroy_item
    Item.find(params[:id]).destroy

    @list = List.find(params[:list])
    render :partial => 'items', :object => @list
  end
  
  def set_item_body
    @item = Item.find(params[:id])
    @item.update_attributes(:body => params[:value])
    
    @item = Item.find(params[:id])
    render :update do |page|
      page.replace 'item_' << params[:id], :partial => 'item', :object => @item
    end
  end

  def set_list_title
    @list = List.find(params[:id])
    @list.update_attributes(:title => params[:value])
    
    @list = List.find(params[:id])
    render :update do |page|
      page.replace 'item_' << params[:id], :partial => 'list', :object => @list
    end
  end

end
