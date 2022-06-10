require 'erb'
require_relative '../http/http_response'
require_relative '../repositories/ratings_repository'

class RatingsController
  def initialize(request:)
    @request = request
  end

  def index
    ratings = RatingsRepository.new.for_user(user_id: 1)

    view_template = File.read("views/my_ratings.rhtml")
    view = ERB.new(view_template).result(binding)

    HTTPResponse.new(
      status_code: 200,
      headers: ["Content-Type: text/html"],
      body: view
    )
  end

  def create
    RatingsRepository.new.create(**request.params)

    HTTPResponse.new(
      status_code: 303,
      headers: ["Content-Type: text/html", "Location: /movies/#{request.params[:movie_id]}"]
    )
  end

  private
  attr_reader :request
end
