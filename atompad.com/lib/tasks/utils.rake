namespace :utils do
  desc "Find pending alerts and send out emails"
  task(:send_alerts => :environment) do
    for alert in Reminder.get_alerts
      if not alert.done
        puts "Emailing #{alert.login}"
        puts "Alert #{alert.title} - #{alert.date}" 
        UserMailer.deliver_reminder(alert)
        alert.update_attributes! :done => true
      end 
    end
  end
end
