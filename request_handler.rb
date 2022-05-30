require 'erb'
require_relative 'http_response'
require_relative 'ratings_repository'
require_relative 'movies_repository'

class RequestHandler
  def initialize(request:)
    @request = request
  end

  def run
    case request.method_and_uri
    when "GET /"
      movies = MoviesRepository.new.all

      view_template = File.read("index.rhtml")
      view = ERB.new(view_template).result(binding)

      HTTPResponse.new(
        status_code: 200,
        headers: ["Content-Type: text/html"],
        body: view
      )
    when "POST /"
      RatingsRepository.new.create(**request.params)

      HTTPResponse.new(
        status_code: 201,
        headers: ["Content-Type: text/html"],
        body: "Rating saved!"
      )
    when "GET /my_ratings"
      ratings = RatingsRepository.new.for_user(user_id: 1)

      view_template = File.read("my_ratings.rhtml")
      view = ERB.new(view_template).result(binding)

      HTTPResponse.new(
        status_code: 200,
        headers: ["Content-Type: text/html"],
        body: view
      )
    else
      HTTPResponse.new(status_code: 404)
    end
  end

  private
  attr_reader :request
end
