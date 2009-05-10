#ActionMailer::Base.delivery_method = :smtp
#ActionMailer::Base.smtp_settings = {
#   :address => "localhost",
#   :port => 25,
#   :domain => "pad.red91.com"
#}

ActionMailer::Base.delivery_method = :sendmail
ActionMailer::Base.sendmail_settings = {
:location       => '/usr/sbin/sendmail',
:arguments      => '-i -t'
}
