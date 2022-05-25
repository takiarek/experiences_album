require_relative 'http_response'

def assert_equal(result, expected_result)
  if result == expected_result
    puts "Passed!"
  else
    puts "Failed!"
    puts
    puts "Expected result:"
    puts
    puts "#{expected_result.inspect}"
    puts
    puts "Actual result:"
    puts
    puts "#{result.inspect}"
  end
end

def when_all_arguments_provided
  puts __method__

  result = HTTPResponse.new(
    protocol: "HTTP/1.1",
    status_code: 200,
    headers: ["Content-Type: text/html"],
    body: "Test response body!"
  ).to_s
  expected_result = "HTTP/1.1 200 OK\r\nContent-Type: text/html\r\n\r\nTest response body!"

  assert_equal(result, expected_result)
end

def when_optional_arguments_omitted
  puts __method__

  result = HTTPResponse.new(status_code: 200).to_s
  expected_result = "HTTP/1.1 200 OK"

  assert_equal(result, expected_result)
end

when_all_arguments_provided
when_optional_arguments_omitted
