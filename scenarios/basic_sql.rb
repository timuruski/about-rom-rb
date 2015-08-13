require 'rom-sql'
require 'ffaker'
require 'support'

class BasicSql < Scenario
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
    end

    class Movies < ROM::Relation[:sql]
      register_as :movies
      dataset :movies

      def find(id)
        where(id: id).one
      end

      def by_title(name)
        where(name: regexp(name))
      end

      def by_director(director)
        where(director_id: director[:id])
      end

      def for_users(users)
        where(director_id: users.map { |user| user[:id] })
      end

      private

      def regexp(raw)
        Regexp.new(Regexp.escape(raw), Regexp::IGNORECASE)
      end
    end

    class UserWithMovies < ROM::Mapper
      relation :users
      register_as :user_with_movies

      reject_keys true

      attribute :id
      attribute :name
      attribute :email

      combine :movies, on: { id: :director_id } do
        attribute :title
      end
    end

    class CreateMovie < ROM::Commands::Create[:sql]
      relation :movies
      register_as :create
      result :one
    end

    ROM.finalize
    seed
  end

  def seed
    20.times do
      user_attrs = {
        name: name = FFaker::Name.name,
        email: FFaker::Internet.email(name),
        city: FFaker::Address.city,
        birthday: FFaker::Time.date
      }

      user = rom.command(:users).create.call(user_attrs).first

      5.times do
        movie_attrs = {
          title: FFaker::Movie.title,
          director_id: user[:id]
        }

       rom.command(:movies).create.call(movie_attrs)
      end
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

      db.create_table? :movies do
        primary_key :id
        column :title, String
        column :director_id, Integer
      end
    end
  end

  def drop_tables
    ROM::SQL.gateway.connection.tap do |db|
      db.drop_table(:users)
      db.drop_table(:movies)
    end
  end

  teardown do
    drop_tables
  end

end
