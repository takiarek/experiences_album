require_relative '../http/http_response'
require_relative '../repositories/moods_ascriptions_repository'

class MoodsAscriptionsController
  def initialize(request:)
    @request = request
  end

  def create
    MoodsAscriptionsRepository.new.upsert(user_id: 1, **request.params)

    HTTPResponse.new(
      status_code: 303,
      headers: ["Content-Type: text/html", "Location: /movies/#{request.params[:movie_id]}"]
    )
  end

  private
  attr_reader :request
end
