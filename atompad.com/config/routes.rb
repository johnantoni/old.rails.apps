ActionController::Routing::Routes.draw do |map|

  map.resources :users
  map.resource  :session
                                                             
  map.forgot_password '/forgot_password', :controller => 'users', :action => 'forgot_password'
  map.reset_password '/reset_password', :controller => 'users', :action => 'reset_password'
  
  map.home '', :controller => 'users', :action => 'index'
  map.connect 'index', :controller => 'users', :action => 'index'
  map.connect 'login', :controller => 'users', :action => 'login'
  map.connect 'signup', :controller => 'users', :action => 'signup'
  map.connect 'logout', :controller => 'users', :action => 'logout'
    
  map.connect 'news', :controller => 'guide', :action => 'news'
  map.connect 'legal', :controller => 'guide', :action => 'legal'
  
  map.user_change_password 'users/:id/change_password', :controller => 'users', :action => 'change_password'

  map.connect ':controller/service.wsdl', :action => 'wsdl'

  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action/:id'

end
