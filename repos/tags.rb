require_relative 'support'

module Tags
  class Relation < ROM::Relation[:sql]
    gateway :default
    dataset :tags
    register_as :tags
  end

  class Create < ROM::Commands::Create[:sql]
    relation :posts
    register_as :create
    input F[:accept_keys, [:name, :post_id]]
    associates :post, key: [:post_id, :post]
  end
end
