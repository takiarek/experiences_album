require 'pg'
require_relative 'test_helpers'
require_relative '../repositories/moods_ascriptions_repository'

class MoodsAscriptionsRepositoryTest
  def upsert
    print_test_name(__method__)
    connection.exec("DELETE FROM #{MoodsAscriptionsRepository::TABLE}")

    moods_ascriptions_repository.upsert(user_id: 3, movie_id: 3, moods_ids: ["10", "12", "14"])
    assert_equal(moods_ascribed_count(connection), 3)

    moods_ascriptions_repository.upsert(user_id: 3, movie_id: 3, moods_ids: ["10", "12", "14"])
    assert_equal(moods_ascribed_count(connection), 3)

    moods_ascriptions_repository.upsert(user_id: 3, movie_id: 3, moods_ids: ["10", "12", "14", "20"])
    assert_equal(moods_ascribed_count(connection), 4)

    moods_ascriptions_repository.upsert(user_id: 3, movie_id: 3, moods_ids: ["10", "12", "20"])
    assert_equal(moods_ascribed_count(connection), 3)
  end

  def where
    print_test_name(__method__)
    connection.exec("DELETE FROM #{MoodsAscriptionsRepository::TABLE}")

    moods_ascriptions_repository.upsert(user_id: 1, movie_id: 1, moods_ids: [11, 18, 19, 20])
    moods_ascriptions_repository.upsert(user_id: 3, movie_id: 3, moods_ids: [10, 12, 14])

    ascriptions = moods_ascriptions_repository.where(user_id: 1, movie_id: 1)
    assert_equal(ascriptions.map(&:mood_id), ["11", "18", "19", "20"])
    assert_equal(ascriptions.all? {|x| x.respond_to?(:id)}, true)
    assert_equal(ascriptions.all? {|x| x.respond_to?(:user_id)}, true)
    assert_equal(ascriptions.all? {|x| x.respond_to?(:movie_id)}, true)

    ascriptions = moods_ascriptions_repository.where(user_id: 3, movie_id: 3)
    assert_equal(ascriptions.map(&:mood_id), ["10", "12", "14"])

    ascriptions = moods_ascriptions_repository.where(user_id: 1, movie_id: 1, only: [:id])
    assert_equal(ascriptions.all? {|x| x.respond_to?(:id)}, true)
    assert_equal(ascriptions.all? {|x| x.respond_to?(:user_id)}, false)
    assert_equal(ascriptions.all? {|x| x.respond_to?(:movie_id)}, false)
    assert_equal(ascriptions.all? {|x| x.respond_to?(:mood_id)}, false)

    ascriptions = moods_ascriptions_repository.where(user_id: 1, movie_id: 1, only: [:id, :user_id])
    assert_equal(ascriptions.all? {|x| x.respond_to?(:id)}, true)
    assert_equal(ascriptions.all? {|x| x.respond_to?(:user_id)}, true)
    assert_equal(ascriptions.all? {|x| x.respond_to?(:movie_id)}, false)
    assert_equal(ascriptions.all? {|x| x.respond_to?(:mood_id)}, false)
  end

  private

  def connection
    @connection ||= PG.connect(dbname: "experiences_album")
  end

  def moods_ascriptions_repository
    @moods_ascriptions_repository ||= MoodsAscriptionsRepository.new
  end
end

test = MoodsAscriptionsRepositoryTest.new

test.create
test.upsert
test.where
