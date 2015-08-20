require 'rom-sql'
require 'ffaker'
require 'support'

class BasicSql < Scenario
  about <<-EOS
  Modeled on Movies and Directors, which are already seeded (the titles are amazing).
  Get a director with:

    director = rom.relation(:directors).first

  Get a director, with all movies:
    directors = rom.relation(:directors)
    movies = relation(:movies).for_directors

    directors.combine(movies).as(:with_movies).first

  EOS

  setup do
    ROM.setup(:sql, 'postgres://localhost/about-rom')

    # CREATE TABLES
    ROM::SQL.gateway.connection.tap do |db|
      db.create_table? :directors do
        primary_key :id
        column :name, String
      end

      db.create_table? :movies do
        primary_key :id
        column :title, String
        column :director_id, Integer
      end
    end

    # CONFIGURE ROM
    class Directors < ROM::Relation[:sql]
      register_as :directors
      dataset :directors

      def by_id(id)
        where(id: id)
      end

      def find(id)
        where(id: id).one
      end

      def by_name(name)
        where(name: regexp(name))
      end

      private

      def regexp(raw)
        Regexp.new(Regexp.escape(raw), Regexp::IGNORECASE)
      end
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

      def for_directors(directors)
        where(director_id: directors.map { |director| director[:id] })
      end

      private

      def regexp(raw)
        Regexp.new(Regexp.escape(raw), Regexp::IGNORECASE)
      end
    end

    class CreateMovie < ROM::Commands::Create[:sql]
      relation :movies
      register_as :create
      result :one
    end

    class CreateDirector < ROM::Commands::Create[:sql]
      relation :directors
      register_as :create
    end

    class WithMovies < ROM::Mapper
      relation :directors
      register_as :with_movies

      reject_keys true

      attribute :id
      attribute :name

      combine :movie, on: { id: :director_id } do
        attribute :id
        attribute :title
      end
    end

    # NOTE: This doesn't quite work.
    class WithTitles < ROM::Mapper
      relation :directors
      register_as :with_titles

      reject_keys true

      attribute :id
      attribute :name

      combine :movies, on: { id: :director_id }
      fold :movies do
        attribute :titles
      end
    end


    ROM.finalize

    # SEED DATA
    20.times do
      director_attrs = {
        name: name = FFaker::Name.name,
      }

      director = rom.command(:directors).create.call(director_attrs).first

      5.times do
        movie_attrs = {
          title: FFaker::Movie.title,
          director_id: director[:id]
        }

       rom.command(:movies).create.call(movie_attrs)
      end
    end
  end

  teardown do
    ROM::SQL.gateway.connection.tap do |db|
      db.drop_table(:directors)
      db.drop_table(:movies)
    end
  end
end
