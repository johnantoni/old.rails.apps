class CreateSignups < ActiveRecord::Migration
  def self.up
    create_table :signups do |t|
      t.column :email, :string
      t.column :created_at, :datetime      
      t.timestamps
    end
  end

  def self.down
    drop_table :signups
  end
end
