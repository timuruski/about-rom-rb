#! /usr/bin/env bundler exec ruby

require 'sequel'

Sequel.connect('postgres://localhost/rom-demo') do |db|
  db.drop_table? :users, :posts, :comments
end
