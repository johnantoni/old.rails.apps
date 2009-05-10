require "easy_messages_system"
ActiveRecord::Base.send :include, ProtonMicro::EasyMessages::Messages
ActionController::Base.send :include, ProtonMicro::EasyMessages::AuthenticatedCommands
