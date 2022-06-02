require 'socket'
require_relative 'http/http_request'
require_relative 'request_handler'

server = TCPServer.new 5001

while session = server.accept
  request = HTTPRequest.new(request_string: session.readpartial(4096))

  request << session.readpartial(4096) until request.complete?

  response = RequestHandler.new(request: request).run

  session.print response.to_s

  session.close
end
