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
    case request.method_and_path
    when "GET /", "GET /movies"
      movies = request.params.any? ? MoviesRepository.new.in_moods(**request.params) : MoviesRepository.new.all

      view_template = File.read("views/movies_index.rhtml")
      view = ERB.new(view_template).result(binding)

      HTTPResponse.new(
        status_code: 200,
        headers: ["Content-Type: text/html"],
        body: view
      )
    when /GET \/movies\/\d/
      movie_id = request.method_and_path.split("/").last

      movie = MoviesRepository.new.find(id: movie_id)
      moods = MoodsRepository.new.all
      ascribed_moods_ids = MoodsAscriptionsRepository.new.where(user_id: 1, movie_id: movie.id, only: ["mood_id"]).map(&:mood_id)

      view_template = File.read("views/show_movie.rhtml")
      view = ERB.new(view_template).result(binding)

      HTTPResponse.new(
        status_code: 200,
        headers: ["Content-Type: text/html"],
        body: view
      )
    when "POST /ratings"
      RatingsRepository.new.create(**request.params)

      HTTPResponse.new(
        status_code: 303,
        headers: ["Content-Type: text/html", "Location: /movies/#{request.params[:movie_id]}"]
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
    when "POST /ascribe_moods"
      MoodsAscriptionsRepository.new.upsert(user_id: 1, **request.params)

      HTTPResponse.new(
        status_code: 201,
        headers: ["Content-Type: text/html"],
        body: "Moods saved!"
      )
    when "GET /movies_in_moods_search"
      moods = MoodsRepository.new.all

      view_template = File.read("views/movies_in_moods_search.rhtml")
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
