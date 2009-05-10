class CreateReminders < ActiveRecord::Migration
  def self.up
    create_table :reminders do |t|
      t.column :user_id, :integer
      t.column :title, :string
      t.column :date, :datetime      
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
      t.column :done, :boolean, :default => false
      t.column :repeat, :boolean, :default => false
    end
    
    execute "alter table reminders add constraint fk_r_users foreign key (user_id) references users(id)"    
  end

  def self.down
    drop_table :reminders
  end
end
