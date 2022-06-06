require 'pg'
require 'net/http'
require_relative 'test_helpers'

connection = PG.connect(dbname: "experiences_album")

def moods_ascribed_count(connection)
  connection.exec("SELECT COUNT(*) FROM moods_ascriptions WHERE user_id = 3 AND movie_id = 2") do |result|
    result.first["count"].to_i
  end
end

connection.exec("DELETE FROM moods_ascriptions")

begin
  response = Net::HTTP.post_form(URI("http://localhost:5001/ascribe_moods"), "user_id" => 3, "movie_id" => 2, "moods_ids[]" => [9, 10, 17])
rescue Errno::ECONNREFUSED
  puts "ERROR: Server not running!"
  return
end

assert_equal(response.code.to_i, 201)
assert_equal(response.message, "Created")
assert_equal(moods_ascribed_count(connection), 3)
