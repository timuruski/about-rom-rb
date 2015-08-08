module DropTables
  def drop_tables
    ROM::SQL.gateway.connection.tap do |db|
      db.drop_table(:posts, :users, :comments)
    end
  end
end
