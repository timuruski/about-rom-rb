#! /usr/bin/env bundler exec ruby

require_relative '../setup_rom'

ROM::SQL.gateway.connection.tap do |db|
  db.drop_table? :users
  db.drop_table? :posts
  db.drop_table? :comments
end
