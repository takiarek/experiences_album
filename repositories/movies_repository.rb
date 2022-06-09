require 'pg'

class MoviesRepository
  TABLE = "movies"

  def initialize(connection: PG.connect(dbname: "experiences_album"))
    @connection = connection
  end

  def all
    movies = connection.exec("SELECT id, title FROM #{TABLE} ORDER BY id ASC") do |result|
      result.map do |movie|
        OpenStruct.new(id: movie["id"], title: movie["title"])
      end
    end

    connection.close

    movies
  end

  def find(id:)
    movie = connection.exec("SELECT * FROM #{TABLE} WHERE id = #{id}") do |result|
      OpenStruct.new(**result.first)
    end

    connection.close

    movie
  end

  def in_moods(moods_ids:)
    connection.type_map_for_results = PG::BasicTypeMapForResults.new(connection)

    connection.exec("SELECT * FROM (SELECT movies.id, movies.title, array_agg(moods.name) as moods_array  FROM movies, moods_ascriptions, moods WHERE moods_ascriptions.mood_id IN (#{moods_ids.join(",")}) AND moods_ascriptions.movie_id = movies.id AND moods_ascriptions.mood_id = moods.id GROUP BY movies.id) x WHERE array_length(moods_array, 1) = #{moods_ids.count}") do |rows|
      rows.map { |row| OpenStruct.new(**row)}
    end
  end

  private
  attr_reader :connection
end
