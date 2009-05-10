class CreateNotes < ActiveRecord::Migration
  def self.up
    create_table :notes do |t|
      t.column :user_id, :integer
      t.column :title, :string
      t.column :body, :text
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
    
    execute "alter table notes add constraint fk_n_users foreign key (user_id) references users(id)"    
  end

  def self.down
    drop_table :notes
  end
end
