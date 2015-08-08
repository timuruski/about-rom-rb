require 'virtus'

# MODELS
class User
  include Virtus.model

  attribute :id, Integer

  attribute :name, String
  attribute :email, String
end

class Post
  include Virtus.model

  attribute :id, Integer
  attribute :author_id, Integer

  attribute :title, String
  attribute :body, String
end

class Comment
  include Virtus.model

  attribute :id, Integer
  attribute :post_id, Integer
  attribute :author_id, Integer

  attribute :body, String
end
