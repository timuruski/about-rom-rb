ROM::SQL.gateway.connection.tap do |db|
  db.drop_table(:posts, :users, :comments)
end
