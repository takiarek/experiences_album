require 'net/http'
require 'pg'
require_relative 'test_helpers'

def ratings_count(connection)
  connection.exec("SELECT COUNT(*) FROM ratings") { |result| result.first["count"].to_i }
end

def last_rating(connection)
  connection.exec("SELECT * FROM ratings ORDER BY id DESC LIMIT 1") do |result|
    {
      "movie_id" => result.first["movie_id"].to_i,
      "rating_value" => result.first["value"].to_i,
    }
  end
end

connection = PG.connect(dbname: "experiences_album")

ratings_count_before = ratings_count(connection)

begin
  response = Net::HTTP.post_form(URI("http://localhost:5001/ratings"), "movie_id" => 1, "rating_value" => 2)
rescue Errno::ECONNREFUSED
  puts "ERROR: Server not running!"
  return
end

ratings_count_after = ratings_count(connection)

assert_equal(response.code.to_i, 201)
assert_equal(response.message, "Created")
assert_equal(ratings_count_after, ratings_count_before + 1)
assert_equal(last_rating(connection), {"movie_id" => 1, "rating_value" => 2})
