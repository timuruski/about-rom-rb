require 'rom-sql'
# require 'rom-mongo'
# require 'rom-redis'

module Users
  class Relation < ROM::Relation[:sql]
    gateway :default
    dataset :users
    register_as :users
  end

  class Create < ROM::Commands::Create[:sql]
    relation :users
    register_as :create
    result :one
  end
end

module Posts
  class Relation < ROM::Relation[:sql]
    gateway :default
    dataset :posts
    register_as :posts
  end

  class Create < ROM::Commands::Create[:sql]
    relation :posts
    register_as :create
    result :one
  end
end

module Comments
  class Relation < ROM::Relation[:sql]
    gateway :default
    dataset :comments
    register_as :comments
  end

  class Create < ROM::Commands::Create[:sql]
    relation :comments
    register_as :create
    result :one
  end
end
