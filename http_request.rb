class HTTPRequest
  def initialize(request_string:)
    @request_string = request_string
  end

  def complete?
    method = method_and_uri.split.first

    return post_request_complete? if method == "POST"

    method == "GET"
  end

  def method_and_uri
    request_string.split(" ")[0..1].join(" ")
  end

  def params
    params_strings = request_string.split("\r\n\r\n")[1]&.split("&") || []
    parse_params(params_strings)
  end

  private
  attr_reader :request_string

  def post_request_complete?
    !request_string.split("\r\n\r\n")[1].nil?
  end

  def parse_params(params_strings)
    params_strings.each_with_object({}) do |param_string, params_hash|
      key, value = param_string.split("=")

      params_hash[key.to_sym] = value
    end
  end
end
