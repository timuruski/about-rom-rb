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
