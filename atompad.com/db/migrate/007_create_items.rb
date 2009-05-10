class CreateItems < ActiveRecord::Migration
  def self.up
    create_table :items do |t|
      t.column :user_id, :integer
      t.column :list_id, :integer
      t.column :title, :string
      t.column :position, :integer
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end

    execute "alter table items add constraint fk_i_users foreign key (user_id) references users(id)"
    execute "alter table items add constraint fk_i_lists foreign key (list_id) references lists(id)"    
  end

  def self.down
    drop_table :items
  end
end
