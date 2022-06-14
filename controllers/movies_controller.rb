require 'erb'
require_relative '../http/http_response'
require_relative '../repositories/movies_repository'
require_relative '../repositories/moods_repository'

class MoviesController
  def initialize(request:)
    @request = request
  end

  def index
    movies = request.params.any? ? MoviesRepository.new.in_moods(**request.params) : MoviesRepository.new.all
    moods = MoodsRepository.new.all

    view_template = File.read("views/movies_index.rhtml")
    view = ERB.new(view_template).result(binding)

    HTTPResponse.new(
      status_code: 200,
      headers: ["Content-Type: text/html"],
      body: view
    )
  end

  def show
    movie_id = request.method_and_path.split("/").last

    movie = MoviesRepository.new.find(id: movie_id)
    moods = MoodsRepository.new.all
    avarage_rating = RatingsRepository.new.avarage_for_movie(user_id: 1, movie_id: movie.id)
    avarage_rating = avarage_rating.to_f if avarage_rating
    ascribed_moods_ids = MoodsAscriptionsRepository.new.where(user_id: 1, movie_id: movie.id, only: ["mood_id"]).map(&:mood_id)
    show_flash_message = request.headers["Referer"].match?(/movies\/#{movie.id}/)

    view_template = File.read("views/show_movie.rhtml")
    view = ERB.new(view_template).result(binding)

    HTTPResponse.new(
      status_code: 200,
      headers: ["Content-Type: text/html"],
      body: view
    )
  end

  private
  attr_reader :request
end
