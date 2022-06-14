class HTTPRequest
  def initialize(request_string:)
    @request_string = request_string
  end

  def complete?
    return post_request_complete? if method == "POST"

    method == "GET"
  end

  def <<(request_string_partial)
    request_string << request_string_partial
  end

  def method_and_path
    "#{method} #{path}"
  end

  def params
    params_strings = body&.split("&") || [] if method == "POST"
    params_strings = query&.split("&") || [] if method == "GET"

    parse_params(params_strings)
  end

  def headers
    request_string.split("\r\n").drop(1).reduce({}) do |hash, header|
      break hash if header.empty?

      key,value = header.split(": ")

      hash[key] = value

      hash
    end
  end

  private
  attr_reader :request_string

  def method
    start_line.split(" ").first
  end

  def path
    uri.split("?").first
  end

  def query
    uri.split("?")[1]
  end

  def uri
    start_line.split(" ")[1]
  end

  def start_line
    request_string.split("\r\n").first
  end

  def post_request_complete?
    !!body
  end

  def body
    request_string.split("\r\n\r\n")[1]
  end

  def parse_params(params_strings)
    params_strings.each_with_object({}) do |param_string, params_hash|
      key, value = param_string.split("=")

      if key.end_with?("%5B%5D")
        new_key = key.delete_suffix("%5B%5D").to_sym
        params_hash[new_key] ||= []
        params_hash[new_key] << value
      else
        params_hash[key.to_sym] = value
      end
    end
  end
end
