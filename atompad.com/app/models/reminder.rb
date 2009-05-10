class Reminder < ActiveRecord::Base
  validates_presence_of :title
  belongs_to :user
 
#  acts_as_list :scope => :user,
#      :order => 'date DESC'      

  def self.get_alerts           
    #@Reminder = Reminder.find_by_sql("SELECT u.login, r.title, r.date FROM users u, reminders r WHERE u.id = r.user_id ")
    @Reminder = Reminder.find_by_sql("select r.* from reminders r where done = False and DATE(date) = DATE(ADDDATE(CURDATE(), 1))")
  end

end
