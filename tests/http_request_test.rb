require_relative 'test_helpers'
require_relative '../http_request'

def http_request(request_string)
  HTTPRequest.new(request_string: request_string)
end

def complete?
  puts __method__

  request_string = ""
  assert_equal(http_request(request_string).complete?, false)

  request_string = "GET"
  assert_equal(http_request(request_string).complete?, true)

  request_string = "POST / HTTP/1.1\r\nHost: localhost:5001\r\n\r\n"
  assert_equal(http_request(request_string).complete?, false)

  request_string = "POST / HTTP/1.1\r\nHost: localhost:5001\r\n\r\nlast line"
  assert_equal(http_request(request_string).complete?, true)
end

complete?
