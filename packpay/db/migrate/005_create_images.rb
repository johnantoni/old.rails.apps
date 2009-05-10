class CreateImages < ActiveRecord::Migration
  def self.up
    create_table :images do |t|
      t.column :user_id, :integer, :null => false
      t.column :default, :boolean, :null => false, :default => false
      t.column :parent_id,  :integer,:null => true
      t.column :content_type, :string, :null => false
      t.column :filename, :string, :null => false    
      t.column :thumbnail, :string, :null => true 
      t.column :size, :integer, :null => false
      t.column :width, :integer, :null => true
      t.column :height, :integer, :null => true
      t.timestamps
    end   
    
    execute "alter table images add constraint fk_i_users foreign key (user_id) references users(id)"
  end

  def self.down
    drop_table :images
  end
end
