require_relative 'http/http_response'
require_relative 'controllers/movies_controller'
require_relative 'controllers/ratings_controller'
require_relative 'controllers/moods_ascriptions_controller'

class RequestHandler
  def initialize(request:)
    @request = request
  end

  def run
    case request.method_and_path
    when "GET /", "GET /movies"
      MoviesController.new(request: request).index
    when /GET \/movies\/\d/
      MoviesController.new(request: request).show
    when "POST /ratings"
      RatingsController.new(request: request).create
    when "GET /my_ratings"
      RatingsController.new(request: request).index
    when "POST /ascribe_moods"
      MoodsAscriptionsController.new(request: request).create
    when "GET /movies_in_moods_search"
      MoviesController.new(request: request).in_moods_search
    else
      HTTPResponse.new(status_code: 404)
    end
  end

  private
  attr_reader :request
end
