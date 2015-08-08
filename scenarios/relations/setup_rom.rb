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
