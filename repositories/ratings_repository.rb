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

  def for_user(user_id:)
    connection = PG.connect(dbname: "experiences_album")

    ratings = connection.exec("SELECT movies.title as movie_title, ROUND(AVG(ratings.value), 2) as avarage_rating from movies, ratings WHERE ratings.user_id=1 AND ratings.movie_id=movies.id GROUP BY movie_title") do |result|
      result.map do |rating|
        OpenStruct.new(movie_title: rating["movie_title"], avarage_rating: rating["avarage_rating"])
      end
    end

    connection.close

    ratings
  end
end
