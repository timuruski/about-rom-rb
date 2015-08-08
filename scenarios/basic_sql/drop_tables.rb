module DropTables
  def drop_tables
    ROM::SQL.gateway.connection.tap do |db|
      db.drop_table(:users)
    end
  end
end
