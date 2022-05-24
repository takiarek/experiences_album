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
end
