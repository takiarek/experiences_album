require 'pg'

class MoviesRepository
  def all
    connection = PG.connect(dbname: "experiences_album")

    movies = connection.exec("SELECT id, title FROM movies ORDER BY id ASC") do |result|
      result.map do |movie|
        OpenStruct.new(id: movie["id"], title: movie["title"])
      end
    end

    connection.close

    movies
  end

  def find(id:)
    connection = PG.connect(dbname: "experiences_album")

    movie = connection.exec("SELECT * FROM movies WHERE id = #{id}") do |result|
      OpenStruct.new(**result.first)
    end

    connection.close

    movie
  end
end
