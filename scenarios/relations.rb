require 'rom-sql'
require 'support'
require_relative 'relations/create_tables'
require_relative 'relations/drop_tables'

class Relations < Scenario
  include CreateTables
  include DropTables

  setup do
    ROM.setup(:sql, 'postgres://localhost/about-rom')

    create_tables
    require_relative 'relations/setup_rom'

    ROM.finalize

    seed
  end

  def seed
    create_user = rom.command(:users).create
    alice = create_user.call(name: 'Alice Smith', email: 'alice@example.com')
    bob = create_user.call(name: 'Bob Anderson', email: 'bob@example.com')

    create_post = rom.command(:posts).create
    post_a = create_post.call(title: "Hello, World!", body: "My first post", author_id: alice[:id])
    post_b = create_post.call(title: "Second is best", body: "I also wrote a post", author_id: bob[:id])

    create_comment = rom.command(:comments).create
    create_comment.call(author_id: bob[:id], post_id: post_a[:id], body: 'Great post!')
    create_comment.call(author_id: alice[:id], post_id: post_b[:id], body: 'I disagree with your conclusion.')
  end

  teardown do
    drop_tables
  end

end
