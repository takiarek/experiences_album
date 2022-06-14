require_relative 'test_helpers'
require_relative '../http/http_request'

def http_request(request_string)
  HTTPRequest.new(request_string: request_string)
end

def complete?
  print_test_name __method__

  request_string = "GET / HTTP/1.1\r\nHost: localhost:5001"
  assert_equal(http_request(request_string).complete?, true)

  request_string = "POST / HTTP/1.1\r\nHost: localhost:5001\r\n\r\n"
  assert_equal(http_request(request_string).complete?, false)

  request_string = "POST / HTTP/1.1\r\nHost: localhost:5001\r\n\r\nlast line"
  assert_equal(http_request(request_string).complete?, true)
end

def method_and_path
  print_test_name __method__

  request_string = "POST / HTTP/1.1\r\nHost: localhost:5001"
  assert_equal(http_request(request_string).method_and_path, "POST /")

  request_string = "POST /movies HTTP/1.1\r\nHost: localhost:5001"
  assert_equal(http_request(request_string).method_and_path, "POST /movies")

  request_string = "GET /movies?query=1 HTTP/1.1\r\nHost: localhost:5001"
  assert_equal(http_request(request_string).method_and_path, "GET /movies")
end

def params
  print_test_name __method__

  request_string = "GET / HTTP/1.1\r\nHost: localhost:5001"
  assert_equal(http_request(request_string).params, {})

  request_string = "POST / HTTP/1.1\r\nHost: localhost:5001\r\n\r\nmovie_id=1&rating_value=2"
  assert_equal(http_request(request_string).params, { movie_id: "1", rating_value: "2" })

  request_string = "POST / HTTP/1.1\r\nHost: localhost:5001\r\n\r\nmovie_id=1&moods_ids%5B%5D=2"
  assert_equal(http_request(request_string).params, { movie_id: "1", moods_ids: ["2"] })

  request_string = "POST / HTTP/1.1\r\nHost: localhost:5001\r\n\r\nmovie_id=1&moods_ids%5B%5D=2&moods_ids%5B%5D=7&moods_ids%5B%5D=12"
  assert_equal(http_request(request_string).params, { movie_id: "1", moods_ids: ["2", "7", "12"] })

  request_string = "GET /movies?movie_id=1&moods_ids%5B%5D=2&moods_ids%5B%5D=7 HTTP/1.1\r\nHost: localhost:5001"
  assert_equal(http_request(request_string).params, { movie_id: "1", moods_ids: ["2", "7"] })
end

def headers
  print_test_name __method__

  request_string = "GET / HTTP/1.1\r\nHost: localhost:5001\r\nReferer: http://localhost:5001/movies/2\r\n\r\nmovie_id=1&rating_value=2"
  assert_equal(http_request(request_string).headers, { "Host" => "localhost:5001", "Referer" => "http://localhost:5001/movies/2" })
end

complete?
method_and_path
params
headers
