class Request
  attr_reader :method, :url, :http_version, :headers
  private attr_reader :raw_lines, :client

  def initialize(client)
    @raw_lines = read_raw_request_lines(client)
    parse!
  end

  def to_s
    <<~END
      #{method} #{url} HTTP/#{http_version}
      #{headers.map { |k, v| "#{k}: #{v}" }.join("\n")}
    END
  end

  private

  def read_raw_request_lines(client)
    lines = []
    lines << client.gets until lines.last&.strip&.empty?
    lines.map(&:chomp)
  end

  def parse!
    @method, @url, rest = raw_lines[0].split(/\s/, 3)

    if (match = rest.match(/HTTP\/(?<major>\d+)\.(?<minor>\d+)/))
      @http_version = "#{match[:major]}.#{match[:minor]}"
    end

    @headers = raw_lines[1..]
      .reject(&:empty?)
      .map { |line|
        line.split(":", 2).map(&:strip)
      }.to_h
  end
end
