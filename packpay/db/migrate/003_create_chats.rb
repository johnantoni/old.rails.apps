class CreateChats < ActiveRecord::Migration
  def self.up
    create_table :chats do |t|
      t.column :name,  :string
      t.column :subject, :integer
    end
  end

  def self.down
    drop_table :chats
  end
end
