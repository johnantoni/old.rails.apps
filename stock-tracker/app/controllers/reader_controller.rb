class ReaderController < ApplicationController

  def index
    #init values
    session[:quote_symbols] = "goog" #"yhoo,goog,msft"
    #show all
    redirect_to(:action => 'all')
  end
  
  def search    
    #search for specific one, and update cache
    @symbol = params[:search_text]
    if !@symbol.blank?
      session[:quote_symbols] = session[:quote_symbols] + "," + @symbol.to_s 
      session[:quote_symbol] = @symbol.to_s 
      redirect_to(:action => "single", :id => session[:quote_symbol])
    else
      redirect_to(:action => "all")
    end
  end

  def single
    #show specific
    @symbol = params[:id]
    @details = scan_full(@symbol)
    @history = scan_history(@symbol)
  end
  
  def init
    #clear cache
    redirect_to(:action => "index")
  end

  def all
    #show all
    @details = scan_light(session[:quote_symbols])
  end
  
end
