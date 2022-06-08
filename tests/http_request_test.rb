require_relative 'test_helpers'
require_relative '../http/http_request'

def http_request(request_string)
  HTTPRequest.new(request_string: request_string)
end

def complete?
  print_test_name __method__

  request_string = ""
  assert_equal(http_request(request_string).complete?, false)

  request_string = "GET"
  assert_equal(http_request(request_string).complete?, true)

  request_string = "POST / HTTP/1.1\r\nHost: localhost:5001\r\n\r\n"
  assert_equal(http_request(request_string).complete?, false)

  request_string = "POST / HTTP/1.1\r\nHost: localhost:5001\r\n\r\nlast line"
  assert_equal(http_request(request_string).complete?, true)
end

def params
  print_test_name __method__

  request_string = ""
  assert_equal(http_request(request_string).params, {})

  request_string = "POST / HTTP/1.1\r\nHost: localhost:5001\r\n\r\nmovie_id=1&rating_value=2"
  assert_equal(http_request(request_string).params, { movie_id: "1", rating_value: "2" })

  request_string = "POST / HTTP/1.1\r\nHost: localhost:5001\r\n\r\nmovie_id=1&moods_ids%5B%5D=2"
  assert_equal(http_request(request_string).params, { movie_id: "1", moods_ids: ["2"] })

  request_string = "POST / HTTP/1.1\r\nHost: localhost:5001\r\n\r\nmovie_id=1&moods_ids%5B%5D=2&moods_ids%5B%5D=7&moods_ids%5B%5D=12"
  assert_equal(http_request(request_string).params, { movie_id: "1", moods_ids: ["2", "7", "12"] })
end

complete?
params
