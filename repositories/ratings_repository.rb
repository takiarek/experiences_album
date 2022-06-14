require 'pg'

class RatingsRepository
  def create(movie_id:, rating_value:)
    connection = PG.connect(dbname: "experiences_album")

    user_id = connection.exec("SELECT id FROM users ORDER BY id ASC LIMIT 1") do |result|
      result.first["id"]
    end

    connection.exec("INSERT INTO ratings (user_id, movie_id, value) VALUES (#{user_id}, #{movie_id}, #{rating_value})")

    connection.close
  end

  def avarage_for_movie(user_id:, movie_id:)
    connection = PG.connect(dbname: "experiences_album")
    connection.type_map_for_results = PG::BasicTypeMapForResults.new(connection)

    result = connection.exec("SELECT ROUND(AVG(ratings.value), 2) as avarage_rating from ratings WHERE ratings.user_id=1 AND ratings.movie_id=#{movie_id}")

    connection.close

    result.first["avarage_rating"]
  end
end
