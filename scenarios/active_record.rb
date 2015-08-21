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

    # CREATE TABLES
    ROM::SQL.gateway.connection.tap do |db|
      db.create_table? :users do
        primary_key :id
        column :name, String
      end
    end

    # DEFINE MODELS
    class User
      include Virtus.model

      attribute :id
      attribute :name

      class << self
        def relation
          ROM.env.relation(:users).as(:user)
        end

        def command
          ROM.env.command(:users).as(:user)
        end

        def find(id)
          relation.by_id(id).one!
        end

        def create(attrs)
          command.create.call(attrs)
        end

        def all
          relation.to_a
        end

        def first
          relation.first
        end

        def count
          relation.count
        end

        def by_name(name)
          relation.by_name(name).to_a
        end
      end

      def command
        ROM.env.command(:users).as(:user)
      end

      def save
        command.update.by_id(id).call(attributes)
      end

      def delete
        command.delete.by_id(id).call
      end
    end

    # DEFINE RELATIONS, COMMANDS AND MAPPERS
    class UserRelation < ROM::Relation[:sql]
      register_as :users
      dataset :users

      def by_id(id)
        where(id: id)
      end

      def by_name(name)
        where(name: regexp(name))
      end

      def count
        dataset.count
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

    # SEED MODELS
    20.times do
      user_attrs = {
        name: name = FFaker::Name.name
      }

      ROM.env.command(:users).create.call(user_attrs).first
    end
  end

  teardown do
    # DROP TABLES
    ROM::SQL.gateway.connection.tap do |db|
      db.drop_table(:users)
    end
  end
end
