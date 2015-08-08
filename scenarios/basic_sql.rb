require 'rom-sql'
require 'ffaker'
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

      def find(id)
        where(id: id).one
      end

      def by_name(name)
        where(name: regexp(name))
      end

      def by_email(email)
        where(email: regexp(email))
      end

      private

      def regexp(raw)
        Regexp.new(Regexp.escape(raw), Regexp::IGNORECASE)
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
    100.times do
      user_attrs = {
        name: name = FFaker::Name.name,
        email: FFaker::Internet.email(name),
        city: FFaker::Address.city,
        birthday: FFaker::Time.date
      }

      rom.command(:users).create.call(user_attrs)
    end
  end

  def create_tables
    ROM::SQL.gateway.connection.tap do |db|
      db.create_table? :users do
        primary_key :id
        column :email, String
        column :name, String
        column :city, String
        column :birthday, DateTime
      end
    end
  end

  def drop_tables
    ROM::SQL.gateway.connection.tap do |db|
      db.drop_table(:users)
    end
  end

  teardown do
    drop_tables
  end

end
