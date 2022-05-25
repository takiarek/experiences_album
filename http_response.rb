class HTTPResponse
  def initialize(protocol: "HTTP/1.1", status_code:, headers: [], body: "")
    @protocol = protocol
    @status_code = status_code
    @headers = headers
    @body = body
  end

  def to_s
    [status_line, headers_lines, empty_line, body].join(separator).strip
  end

  private
  attr_reader :protocol, :status_code, :headers, :body

  def status_line
    "#{protocol} #{status}"
  end

  def headers_lines
    headers.join(separator)
  end

  def empty_line
    ""
  end

  def separator
    "\r\n"
  end

  def status
    "#{status_code} #{status_text}"
  end

  def status_text
    {
      200 => "OK",
      201 => "Created",
      404 => "Not Found",
    }[status_code]
  end
end
