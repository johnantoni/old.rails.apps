ActionController::Routing::Routes.draw do |map|
  
  map.home '', :controller => "signup", :action => "index"
  map.connect 'index', :controller => "account", :action => "index"
  
  # account routes
  map.connect 'login', :controller => "account", :action => "login"
  map.connect 'signup', :controller => "account", :action => "signup"
  map.connect 'profile', :controller => "account", :action => "profile"

  # guide routes
  map.connect 'about', :controller => "guide", :action => "about"
  map.connect 'contact', :controller => "guide", :action => "contact"
  map.connect 'terms', :controller => "guide", :action => "terms"
          
  # inbox routes
  map.with_options :controller => 'account' do |m|  
    m.compose '/account/message/send', :action => 'send_message' 
    m.delete 'account/message/delete/:id', :action => 'delete_message' 
    m.inbox '/account/inbox', :action => 'inbox' 
    m.outbox '/account/outbox', :action => 'outbox' 
    m.trashbin '/account/trashbin', :action => 'trash_bin' 
    m.reply '/account/message/reply/:id', :action => 'reply_to_message' 
    m.view '/account/message/view/:id', :action => 'view_message'  
  end

  # change password route
  map.user_change_password 'users/:id/change_password', :controller => 'users', :action => 'change_password'

  # defaults
  map.connect ':controller/service.wsdl', :action => 'wsdl'
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action/:id'

end
