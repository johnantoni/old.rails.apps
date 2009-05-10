# Easy_Messages
module ProtonMicro
  module EasyMessages
    module Messages

      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def easy_messages(options = {})
        
          has_many :messages_as_sender,    
                   :class_name => "Message", 
                   :foreign_key => "sender_id"
          
          has_many :messages_as_receiver,  
                   :class_name => "Message", 
                   :foreign_key => "receiver_id"
          
          has_many :users_who_messaged_me, 
                   :through => :messages_as_receiver, 
                   :source => :sender,
                   :select => "users.*, messages.id AS message_id, messages.subject, messages.body, messages.created_at AS sent_at, messages.read_at"

          has_many :users_whom_i_have_messaged,
                   :through => :messages_as_sender,
                   :source => :receiver,
                   :select => "users.*, messages.id AS message_id, messages.subject, messages.body, messages.created_at AS sent_at, messages.read_at"

          has_many :unread_messages,
                   :through => :messages_as_receiver,
                   :source => :sender,
                   :conditions => "messages.read_at IS NULL",
                   :select => "users.*, messages.id AS message_id, messages.subject, messages.body, messages.created_at AS sent_at, messages.read_at"
          
          has_many :read_messages,
                   :through => :messages_as_receiver,
                   :source => :sender,
                   :conditions => "messages.read_at IS NOT NULL",
                   :select => "users.*, messages.id AS message_id, messages.subject, messages.body, messages.created_at AS sent_at, messages.read_at"
                   
          has_many :inbox_messages,  
                   :class_name => "Message", 
                   :foreign_key => "receiver_id",
                   :conditions => "receiver_deleted IS NULL",
                   :order => "created_at DESC"
                   
          has_many :outbox_messages,  
                   :class_name => "Message", 
                   :foreign_key => "sender_id",
                   :conditions => "sender_deleted IS NULL",
                   :order => "created_at DESC"
                   
          has_many :trashbin_messages,  
                   :class_name => "Message", 
                   :foreign_key => "receiver_id",
                   :conditions => "receiver_deleted = true and receiver_purged IS NULL",
                   :order => "created_at DESC"

          include ProtonMicro::EasyMessages::Messages::InstanceMethods
        end
      end

      module InstanceMethods
        # Returns a list of all the users who the user has messaged
        def users_messaged
          self.users_whom_i_have_messaged
        end
  
        # Returns a list of all the users who have messaged the user
        def users_messaged_by
          self.users_who_messaged_me
        end
  
        # Returns a list of all the users who the user has mailed or been mailed by
        def all_messages
          self.users_messaged + self.users_messaged_by
        end
  
        # Alias for unread messages
        def new_messages
          self.unread_messages
        end
  
        # Alias for read messages
        def old_messages
          self.read_messages
        end
        
        # Accepts an email object and flags the email as deleted by sender
        def delete_from_sent(message)
          if message.sender_id == self.id
            message.update_attribute :sender_deleted, true
            return true
          else
            return false
          end
        end
  
        # Accepts an email object and flags the email as deleted by receiver
        def delete_from_received(message)
          if message.receiver_id == self.id
            message.update_attribute :receiver_deleted, true
            return true
          else
            return false
          end
        end
  
        # Accepts a user object as the receiver, and an email
        # and creates an email relationship joining the two users
        def send_message(receiver, message)
          Message.create!(:sender => self, :receiver => receiver, :subject => message.subject, :body => message.body)
        end        
      end   
    end

    module AuthenticatedCommands
      
      def self.included(base)
        base.extend ClassMethods
      end
      
      module ClassMethods
        # Authenticated_Commands assumes you have Acts_As_Authenticated[http://technoweenie.stikipad.com/plugins/show/Acts+as+Authenticated] installed as it uses
        # it's methods and model.
        def authenticated_commands(options ={})
          
          helper :easy_messages
          
          before_filter :login_required, :only => [:delete_message, :inbox, :outbox, :reply_to_message, :send_message, :trash_bin, :view_message]
          
          include ProtonMicro::EasyMessages::AuthenticatedCommands::InstanceMethods
        end
      end
        
      module InstanceMethods
        # Performs a "soft" delete of a message then check if it can do a destroy on the message
        # * Marks Inbox messages as "receiver deleted" essentially moving the message to the Trash Bin
        # * Marks Outbox messages as "sender_deleted" and "purged" removing the message from [:inbox_messages, :outbox_messages, :trashbin_messages]
        # * Marks Trash Bin messages as "receiver purged"
        # * Checks to see if both the sender and reciever have purged the message.  If so, the message record is destroyed
        #
        # Returns to the updated view of the current "mailbox"
        def delete_message          
          if request.post? && !params[:to_delete].nil?
            messages = params[:to_delete].map { |m| Message.find_by_id(m) } 
            
            messages.delete(nil) 
            
            messages.each do |m| 
              if can_view(m)
                case session[:mail_box]
                when "inbox"
                  m.receiver_deleted = true
                  m.save(false)                
                when "outbox"
                  m.sender_deleted = true
                  m.sender_purged = true
                  m.save(false)  
                when "trash_bin"
                  m.receiver_purged = true
                  m.save(false) 
                end
                purge_message(m)
              end
            end
          end
          
          redirect_to :action => session[:mail_box]
        end
        
        # Displays all new and read and undeleted messages in the User's inbox
        def inbox
          @messages = current_user.inbox_messages
          session[:mail_box] = "inbox"
          render :action => "messages"
        end
        
        # Displays all messages sent by the user
        def outbox
          @messages = current_user.outbox_messages
          session[:mail_box] = "outbox"
          render :action => "messages"
        end
        
        # Displays all messages deleted from the user's inbox
        def trash_bin
          @messages = current_user.trashbin_messages
          session[:mail_box] = "trash_bin"
          render :action => "messages"
        end
        
        # Prepares a message for reply and displays an editable form
        def reply_to_message
          @message = Message.find_by_id(params[:id])
          
          if !@message.nil? && can_view(@message) 
            @message.recipient = @message.sender_name
            @message.subject = "Re: " + @message.subject 
            @message.body = "\n\n___________________________\n" + @message.sender_name + " wrote:\n\n" + @message.body
            render :action => "send_message" 
          else
            flash[:notice] = "Please keep your eyes on your own messages."
            redirect_to :action => "inbox"
          end  
        end
        
        # Creates a new message and loads it into the sender's outbox
        def send_message      
          @message = Message.new((params[:message] || {}).merge(:sender => current_user))
          
          if request.post? and @message.save
            flash.now[:notice] = "Message sent"
            @message = Message.new
            redirect_to :action => "outbox"
          end
        end
        
        # Displays a message and sets it as read
        def view_message
          @message = Message.find_by_id(params[:id])
          
          if !@message.nil? && can_view(@message)
            if current_user.id == @message.receiver_id
              @message.read_at = Time.now
              @message.save(false)
            end
            render :action => "message_view" 
          else
            flash[:notice] = "Please keep your eyes on your own messages."
            redirect_to :action => "inbox"
          end     
        end
        
        protected
          
        # Security check to make sure the requesting user is either the sender (for outbox display) or the receiver (for inbox or trash_bin display)
        def can_view(message)
          true if current_user.id == message.sender_id || current_user.id == message.receiver_id
        end
        
        # Performs a hard delete of a message.  Should only be called from delete_message
        def purge_message(message)
          if message.sender_purged && message.receiver_purged
            message.destroy
          end
        end
      end    
    end
  end
end