require 'pg'
require_relative 'test_helpers'
require_relative '../repositories/movies_repository'
require_relative '../repositories/moods_ascriptions_repository'

class MoodsAscriptionsRepositoryTest
  def in_moods
    print_test_name(__method__)

    connection.exec("DELETE FROM #{MoodsAscriptionsRepository::TABLE}")

    moods_ascriptions_repository.upsert(user_id: 1, movie_id: 1, moods_ids: [11, 19])
    moods_ascriptions_repository.upsert(user_id: 1, movie_id: 2, moods_ids: [11, 14])
    moods_ascriptions_repository.upsert(user_id: 1, movie_id: 3, moods_ids: [12, 14])
    moods_ascriptions_repository.upsert(user_id: 1, movie_id: 4, moods_ids: [12, 17])

    movies = movies_repository.in_moods(moods_ids: [11, 14])
    assert_equal(movies.map(&:id), [2])

    movies = movies_repository.in_moods(moods_ids: [11])
    assert_equal(movies.map(&:id), [1,2])

    movies = movies_repository.in_moods(moods_ids: [11, 14, 17])
    assert_equal(movies.map(&:id), [])
  end

  private

  def connection
    @connection ||= PG.connect(dbname: "experiences_album")
  end

  def movies_repository
    @movies ||= MoviesRepository.new
  end

  def moods_ascriptions_repository
    @moods_ascriptions_repository ||= MoodsAscriptionsRepository.new
  end
end

test = MoodsAscriptionsRepositoryTest.new

test.in_moods
