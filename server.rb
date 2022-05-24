require 'socket'
require_relative 'ratings_repository'

def request_method(request_string)
  request_string.split(" ").first
end

def request_params(request_string)
  params_string = request_string.split("\r\n\r\n")[1]&.split("&") || []
  parse_params(params_string)
end

def parse_params(params_strings)
  params_strings.each_with_object({}) do |param_string, params_hash|
    key, value = param_string.split("=")

    params_hash[key.to_sym] = value
  end
end

server = TCPServer.new 5001

while session = server.accept
  request_string = session.readpartial(4096)

  if request_method(request_string) == "GET"
    session.print "HTTP/1.1 404\r\n"
    session.close
    next
  end

  params = request_params(request_string)

  RatingsRepository.new.create(**params)

  session.print "HTTP/1.1 200\r\n"
  session.print "Content-Type: text/html\r\n"
  session.print "\r\n"
  session.print "Rating saved!"

  session.close
end
