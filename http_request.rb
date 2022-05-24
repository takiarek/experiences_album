class HTTPRequest
  def initialize(request_string:)
    @request_string = request_string
  end

  def method
    request_string.split(" ").first
  end

  def params
    params_string = request_string.split("\r\n\r\n")[1]&.split("&") || []
    parse_params(params_string)
  end

  private
  attr_reader :request_string

  def parse_params(params_strings)
    params_strings.each_with_object({}) do |param_string, params_hash|
      key, value = param_string.split("=")

      params_hash[key.to_sym] = value
    end
  end
end
