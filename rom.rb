require 'bundler/setup'
require 'rom-sql'

ROM.setup(:sql, 'postgres://localhost/rom-demo')

module Users
  class Relation < ROM::Relation[:sql]
    gateway :default
    dataset :users
    register_as :users
  end

  class Create < ROM::Commands::Create[:sql]
    relation :users
    register_as :create
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
  end
end

ROM.finalize
