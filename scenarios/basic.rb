require 'rom-sql'
require 'support'

class Basic < Scenario
  setup do
    ROM.setup(:sql, 'postgres://localhost/about-rom')

    ROM::SQL.gateway.connection.tap do |db|
      db.create_table :posts do
        primary_key :id
        column :author_id, :integer
        column :title, String
        column :body, :text
      end

      db.create_table :users do
        primary_key :id
        column :email, String
        column :name, String
      end

      db.create_table :comments do
        primary_key :id
        column :post_id, :integer
        column :author_id, :integer
        column :body, :text
      end
    end

    class Users < ROM::Relation[:sql]
      gateway :default
      dataset :users
      register_as :users
    end

    class CreateUser < ROM::Commands::Create[:sql]
      relation :users
      register_as :create
      result :one
    end

    class Posts < ROM::Relation[:sql]
      gateway :default
      dataset :posts
      register_as :posts
    end

    class CreatePost < ROM::Commands::Create[:sql]
      relation :posts
      register_as :create
      result :one
    end

    class Comments < ROM::Relation[:sql]
      gateway :default
      dataset :comments
      register_as :comments
    end

    class CreateComment < ROM::Commands::Create[:sql]
      relation :comments
      register_as :create
      result :one
    end

    ROM.finalize
  end

  teardown do
    ROM::SQL.gateway.connection.tap do |db|
      db.drop_table(:posts, :users, :comments)
    end
  end
end
