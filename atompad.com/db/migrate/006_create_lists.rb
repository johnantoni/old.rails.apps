class CreateLists < ActiveRecord::Migration
  def self.up
    create_table :lists do |t|
      t.column :title, :string
      t.column :position, :integer
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
  end

  def self.down
    drop_table :lists
  end
end
