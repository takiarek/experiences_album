require 'socket'
require_relative 'http_request'
require_relative 'request_handler'

server = TCPServer.new 5001

while session = server.accept
  request_string = session.readpartial(4096)
  request = HTTPRequest.new(request_string: request_string)

  until request.complete? do
    request_string << session.readpartial(4096)
    request = HTTPRequest.new(request_string: request_string)
  end

  response = RequestHandler.new(request: request).run

  session.print response.to_s

  session.close
end
