require 'socket'
require_relative 'http_request'
require_relative 'ratings_repository'

server = TCPServer.new 5001

while session = server.accept
  request = HTTPRequest.new(request_string: session.readpartial(4096))

  case request.method_and_uri
  when "GET /"
    index_html = File.read("index.html")

    session.print "HTTP/1.1 200\r\n"
    session.print "Content-Type: text/html\r\n"
    session.print "\r\n"
    session.print index_html
  when "POST /"
    RatingsRepository.new.create(**request.params)

    session.print "HTTP/1.1 200\r\n"
    session.print "Content-Type: text/html\r\n"
    session.print "\r\n"
    session.print "Rating saved!"
  else
    session.print "HTTP/1.1 404\r\n"
  end

  session.close
end