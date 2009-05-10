class UserMailer < ActionMailer::Base 
    
  def registration(user)
    recipients  user.login
    from        "admin@bownz.red91.com"
    subject     "bownz.com – Registration email"
    body        :user => user
  end

  def pw_reset_link(user)
    recipients user.login
    from 'admin@bownz.red91.com'
    subject "bownz.com - Password Recovery"
    body :url => "http://bownz.red91.com/account/reset_password/#{user.pw_reset_code}"
  end 

end
