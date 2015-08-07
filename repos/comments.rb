module Comments
  class Relation < ROM::Relation[:sql]
    gateway :default
    dataset :comments
    register_as :comments
  end

  class Cache < ROM::Relation[:redis]
    gateway :cache
    dataset :comments
    register_as :comments_cache
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
