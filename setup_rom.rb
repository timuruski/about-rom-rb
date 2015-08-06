require 'rom-sql'
# require 'rom-mongo'
# require 'rom-redis'

require_relative 'models'

ROM.setup(:sql, 'postgres://localhost/rom-demo')

module Repository
  def rom
    @rom ||= ROM.env
  end
end

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

  class AsUser < ROM::Mapper
    relation :users
    register_as :user
    model User
  end

  class << self
    include Repository

    def all
      rom.relation(:users).as(:user).to_a
    end

    def first
      rom.relation(:users).as(:user).first
    end
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

  class AsPost < ROM::Mapper
    relation :posts
    register_as :post
    model Post
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

  class AsComment < ROM::Mapper
    relation :comments
    register_as :comment
    model Comment
  end
end

ROM.finalize
