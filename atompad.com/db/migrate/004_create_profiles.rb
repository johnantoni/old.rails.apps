class CreateProfiles < ActiveRecord::Migration
  def self.up
    create_table "profiles", :force => true do |t|
      t.column :user_id, :integer, :null => false

      t.column :firstname, :string
      t.column :lastname, :string
      t.column :dob, :date
      t.column :about, :text
      t.column :country, :string
      
      t.column :tel_mobile, :string
      t.column :tel_home, :string
      t.column :tel_work, :string
      
      t.column :legal_terms, :boolean, :default => true
    end
  end

  def self.down
    drop_table "profiles"
  end
end
