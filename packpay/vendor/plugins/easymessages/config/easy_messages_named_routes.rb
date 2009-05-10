# Add these names routes to your project's config/routes.rb

map.with_options :controller => 'account' do |m|
  m.compose '/account/message/send', :action => 'send_message'
  m.delete 'account/message/delete/:id', :action => 'delete_message'
  m.inbox '/account/inbox', :action => 'inbox'
  m.outbox '/account/outbox', :action => 'outbox'
  m.trashbin '/account/trashbin', :action => 'trash_bin'
  m.reply '/account/message/reply/:id', :action => 'reply_to_message' 
  m.view '/account/message/view/:id', :action => 'view_message'
end