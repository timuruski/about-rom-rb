require 'rom-sql'
require 'ffaker'
require 'support'
require 'virtus'

class ActiveRecord < Scenario
  about <<-EOS
  Users are already seeded, get the first user with:

    user = User.first #=> #<ActiveRecord::User @id=1, @name="Alice">

  User can be updated and saved.

    user.name = 'Bob'
    user.save
    User.find(user.id) #=> #<ActiveRecord::User @id=1, @name="Bob">

  Users can also be deleted.

    user.delete
    User.find(user.id) #=> nil
  EOS
  setup do
    ROM.setup(:sql, 'postgres://localhost/about-rom')
    create_tables

    class User
      include Virtus.model

      attribute :id
      attribute :name

      class << self
        def relation
          ROM.env.relation(:users).as(:user)
        end

        def find(id)
          relation.find(id).one
        end

        def by_name(name)
          relation.by_name(name).to_a
        end
      end

      def command
        ROM.env.command(:users).as(:user)
      end

      def save
        command.update.find(id).call(attributes)
      end

      def delete
        command.delete.find(id).call
      end
    end


    class Users < ROM::Relation[:sql]
      register_as :users
      dataset :users

      def find(id)
        where(id: id)
      end

      def by_name(name)
        where(name: regexp(name))
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

    class UpdateUser < ROM::Commands::Update[:sql]
      relation :users
      register_as :update
      result :one
    end

    class DeleteUser < ROM::Commands::Delete[:sql]
      relation :users
      register_as :delete
      result :one
    end

    class UserMapper < ROM::Mapper
      model User
      relation :users
      register_as :user
    end

    ROM.finalize
    seed
  end

  def seed
    20.times do
      user_attrs = {
        name: name = FFaker::Name.name
      }

      rom.command(:users).create.call(user_attrs).first
    end
  end

  def create_tables
    ROM::SQL.gateway.connection.tap do |db|
      db.create_table? :users do
        primary_key :id
        column :name, String
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
