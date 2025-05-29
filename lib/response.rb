class Response
  private attr_reader :version, :status, :message, :headers, :body

  def initialize(
    body,
    version: "1.1",
    status: 200,
    message: "OK",
    headers: {}
  )
    @version = version
    @status = status
    @message = message
    @headers = default_headers(body).merge(headers)
    @body = body
  end

  def to_s
    <<~END.chomp
      HTTP/#{version} #{status} #{message}\r
      #{headers.map { |k, v| "#{k}: #{v}" }.join("\r\n")}\r
      \r
      #{body}
    END
  end

  private

  def default_headers(body)
    {
      "Content-Type" => "text/html",
      "Content-Length" => body.bytesize.to_s
    }
  end
end
