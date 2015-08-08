module CreateTables
  def create_tables
    ROM::SQL.gateway.connection.tap do |db|
      db.create_table? :users do
        primary_key :id
        column :email, String
        column :name, String
      end
    end
  end
end
