require 'pg'
require_relative 'test_helpers'
require_relative '../repositories/ratings_repository'

class RatingsRepositoryTest
  def create
    print_test_name(__method__)

    connection.exec("DELETE FROM ratings")

    ratings_repository.create(movie_id: 1, rating_value: 10)
    ratings_repository.create(movie_id: 1, rating_value: 5)
    ratings_repository.create(movie_id: 2, rating_value: 7)

    ratings = connection.exec("SELECT * FROM ratings") do |rows|
      rows.map { |row| OpenStruct.new(user_id: row["user_id"], movie_id: row["movie_id"], value: row["value"]) }
    end

    assert_equal(ratings.map(&:movie_id), [1,1,2])
    assert_equal(ratings.map(&:value), [10,5,7])
  end

  def avarage_for_movie
    print_test_name(__method__)

    connection.exec("DELETE FROM ratings")

    ratings_repository.create(movie_id: 1, rating_value: 5)
    ratings_repository.create(movie_id: 1, rating_value: 3)
    ratings_repository.create(movie_id: 2, rating_value: 10)

    avarage_rating = ratings_repository.avarage_for_movie(user_id: 1, movie_id: 1)
    assert_equal(avarage_rating, 4)
    avarage_rating = ratings_repository.avarage_for_movie(user_id: 1, movie_id: 2)
    assert_equal(avarage_rating, 10)
  end

  private

  def ratings_repository
    @ratings_repository ||= RatingsRepository.new
  end

  def connection
    @connection ||= PG.connect(dbname: "experiences_album")
    @connection.type_map_for_results = PG::BasicTypeMapForResults.new(@connection)

    @connection
  end
end

test = RatingsRepositoryTest.new

test.create
test.avarage_for_movie
