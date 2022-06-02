require 'erb'
require_relative 'http/http_response'
require_relative 'repositories/ratings_repository'
require_relative 'repositories/movies_repository'
require_relative 'repositories/moods_repository'
require_relative 'repositories/moods_ascriptions_repository'

class RequestHandler
  def initialize(request:)
    @request = request
  end

  def run
    case request.method_and_uri
    when "GET /"
      movies = MoviesRepository.new.all

      view_template = File.read("views/movies_index.rhtml")
      view = ERB.new(view_template).result(binding)

      HTTPResponse.new(
        status_code: 200,
        headers: ["Content-Type: text/html"],
        body: view
      )
    when /GET \/movies\/\d/
      movie_id = request.method_and_uri.split("/").last

      movie = MoviesRepository.new.find(id: movie_id)

      view_template = File.read("views/show_movie.rhtml")
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

      view_template = File.read("views/my_ratings.rhtml")
      view = ERB.new(view_template).result(binding)

      HTTPResponse.new(
        status_code: 200,
        headers: ["Content-Type: text/html"],
        body: view
      )
    when "GET /ascribe_moods"
      movies = MoviesRepository.new.all
      moods = MoodsRepository.new.all

      view_template = File.read("views/ascribe_moods.rhtml")
      view = ERB.new(view_template).result(binding)

      HTTPResponse.new(
        status_code: 200,
        headers: ["Content-Type: text/html"],
        body: view
      )
    when "POST /ascribe_moods"
      MoodsAscriptionsRepository.new.create(user_id: 1, **request.params)

      HTTPResponse.new(
        status_code: 201,
        headers: ["Content-Type: text/html"],
        body: "Moods saved!"
      )
    else
      HTTPResponse.new(status_code: 404)
    end
  end

  private
  attr_reader :request
end
