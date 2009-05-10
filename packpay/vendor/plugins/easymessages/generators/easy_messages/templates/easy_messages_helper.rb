module EasyMessagesHelper

  # Reply Button
  def ezm_button_to_reply(message)
    button_to "Reply", reply_url(:id => message)  
  end
  
  # Checkbox for marking a message for deletion
  def ezm_delete_check_box(message)
    check_box_tag 'to_delete[]', message.id
  end
  
  # Link to view the inbox
  def ezm_link_to_inbox
    link_to "Inbox", inbox_url
  end
  
  # Link to view the outbox
  def ezm_link_to_outbox
    link_to "Sent", outbox_url
  end
  
  # Link to view the message
  def ezm_link_to_message(message)
    link_to "#{ezm_subject_and_status(message)}", view_url(:id => message)
  end
  
  # Link to compose a message
  def ezm_link_to_send_message
    link_to "Write", compose_url
  end
  
  # Link to view the trash bin
  def ezm_link_to_trash_bin
    link_to "Trash", trashbin_url
  end
  
  # Generic menu
  def ezm_message_menu
    ezm_link_to_inbox + "|" + ezm_link_to_send_message + "|" + ezm_link_to_outbox + "|" + ezm_link_to_trash_bin
  end
  
  # Dynamic data for the sender/receiver column in the messages.rhtml view
  def ezm_sender_or_receiver(message)
    if session[:mail_box] == "outbox"
      message.receiver_name
    # Used for both inbox and trashbin
    else
      message.sender_name
    end
  end
  
  # Dynamic label for the sender/receiver column in the messages.rhtml view
  def ezm_sender_or_receiver_label
    if session[:mail_box] == "outbox"
      "Recipient"
    # Used for both inbox and trashbin
    else
      "Sender"
    end
  end
  
  # Pretty format for message sent date/time
  def ezm_sent_at(message)
    message.created_at.to_date.strftime('%m/%d/%Y') + " " + message.created_at.strftime('%I:%M %p').downcase
  end

  # Pretty format for message.subject which appeads the status (Deleted/Unread)
  def ezm_subject_and_status(message)
    if message.receiver_deleted?
      message.subject + " (Deleted)" 
    elsif message.read_at.nil?
      message.subject + " (Unread)"  
    else 
      message.subject
    end
  end

end