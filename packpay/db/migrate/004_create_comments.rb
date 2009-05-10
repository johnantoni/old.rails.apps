class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.column :user_id,  :integer, :null => false
      t.column :chat_id,  :integer, :null => false
      t.column :comment,  :string
      t.column :created_at,                 :datetime
      t.column :updated_at,                 :datetime
            
      t.timestamps
    end
    
    execute "alter table comments add constraint fk_c_users foreign key (user_id) references users(id)"
    execute "alter table comments add constraint fk_c_chats foreign key (chat_id) references chats(id)"    
  end

  def self.down
    drop_table :comments
  end
end
