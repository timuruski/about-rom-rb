#! /usr/bin/env bundler exec ruby

require 'rom-sql'

ROM.setup(:sql, 'postgres://localhost/rom-demo')

ROM::SQL.gateway.connection.tap do |db|
  db.create_table? :users do
    primary_key :id
    column :email, String
    column :name, String
  end

  db.create_table? :posts do
    primary_key :id
    column :author_id, :integer
    column :title, String
    column :body, :text
  end

  db.create_table? :comments do
    primary_key :id
    column :post_id, :integer
    column :author_id, :integer
    column :body, :text
  end
end
