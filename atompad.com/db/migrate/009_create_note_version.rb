class CreateNoteVersion < ActiveRecord::Migration
  def self.up
    Note.create_versioned_table do |t| 
      t.column :version,    :integer 
      t.column :user_id,    :integer
      t.column :title,      :string
      t.column :body,       :text
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
      t.column :position,   :integer
    end
    
    execute "alter table note_versions add constraint fk_nv_users foreign key (user_id) references users(id)"
  end

  def self.down
    Note.drop_versioned_table
  end
end
