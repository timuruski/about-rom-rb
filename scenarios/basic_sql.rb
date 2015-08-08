require 'rom-sql'
require 'support'
require_relative 'basic_sql/create_tables'
require_relative 'basic_sql/drop_tables'

class BasicSql < Scenario
  include CreateTables
  include DropTables

  setup do
    ROM.setup(:sql, 'postgres://localhost/about-rom')
    create_tables

    class Users < ROM::Relation[:sql]
      register_as :users
      dataset :users

      def by_name(name)
        where(name: name)
      end
    end

    class CreateUser < ROM::Commands::Create[:sql]
      relation :users
      register_as :create
      result :one
    end

    ROM.finalize
    seed
  end

  def seed
    create_user = rom.command(:users).create
    create_user.call(name: 'Alice Smith', email: 'alice@example.com')
    create_user.call(name: 'Bob Anderson', email: 'bob@example.com')
    create_user.call(name: 'Charlie Edwards', email: 'charlie@example.com')
    create_user.call(name: 'Diane Simpson', email: 'diane@example.com')
  end

  teardown do
    drop_tables
  end

end
