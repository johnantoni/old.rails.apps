class Addcategories < ActiveRecord::Migration
  def self.up
    execute "insert into categories (name) values ('Entertainment');"
    execute "insert into categories (name) values ('Lifestyle');"
    execute "insert into categories (name) values ('Technology');"
    execute "insert into categories (name) values ('Theatre');"
    execute "insert into categories (name) values ('Film');"
    execute "insert into categories (name) values ('Restaurant');"
    execute "insert into categories (name) values ('Club');"
  end

  def self.down
  end
end
