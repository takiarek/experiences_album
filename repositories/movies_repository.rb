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
end
