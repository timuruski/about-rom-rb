require 'bundler/setup'
require 'sequel'
require 'pg'

Sequel.connect('postgres://localhost/rom-demo') do |db|
  db.drop_table? :users, :posts

  db.create_table :users do
    primary_key :id
    text :email
    text :name
  end

  db.create_table :posts do
    primary_key :id
    integer :user_id
  end
end
