require 'socket'
require 'erb'
require_relative 'http_request'
require_relative 'http_response'
require_relative 'ratings_repository'
require_relative 'movies_repository'

server = TCPServer.new 5001

while session = server.accept
  request = HTTPRequest.new(request_string: session.readpartial(4096))

  case request.method_and_uri
  when "GET /"
    movies = MoviesRepository.new.all

    view_template = File.read("index.rhtml")
    view = ERB.new(view_template).result

    response = HTTPResponse.new(
      status_code: 200,
      headers: ["Content-Type: text/html"],
      body: view
    )
  when "POST /"
    RatingsRepository.new.create(**request.params)

    response = HTTPResponse.new(
      status_code: 201,
      headers: ["Content-Type: text/html"],
      body: "Rating saved!"
    )
  when "GET /my_ratings"
    ratings = RatingsRepository.new.for_user(user_id: 1)

    view_template = File.read("my_ratings.rhtml")
    view = ERB.new(view_template).result

    response = HTTPResponse.new(
      status_code: 200,
      headers: ["Content-Type: text/html"],
      body: view
    )
  else
    response = HTTPResponse.new(status_code: 404)
  end

  session.print response.to_s

  session.close
end
