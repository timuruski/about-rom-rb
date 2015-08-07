module Posts
  class Relation < ROM::Relation[:sql]
    gateway :default
    dataset :posts
    register_as :posts
  end

  class Metadata < ROM::Relation[:mongo]
    gateway :meta
    dataset :posts
    register_as :posts_meta
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
