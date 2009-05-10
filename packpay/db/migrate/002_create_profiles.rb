class CreateProfiles < ActiveRecord::Migration
  def self.up
    create_table "profiles", :force => true do |t|
      t.column :user_id, :integer, :null => false

      t.column :firstname, :string
      t.column :lastname, :string
      t.column :dob, :date
      t.column :gender, :string, :default => "Male"
      t.column :about, :string
      
      t.column :location, :string
      t.column :postcode, :string
      t.column :country, :string
      
      t.column :tel_mobile, :string
      t.column :tel_home, :string
      t.column :tel_work, :string
      
      t.column :legal_terms, :boolean
    end
  end

  def self.down
    drop_table "profiles"
  end
end
