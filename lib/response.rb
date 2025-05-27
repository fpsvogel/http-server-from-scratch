class Response
  private attr_reader :exception

  def initialize(exception = nil)
    @exception = exception
  end

  def to_s
    headers = <<~END
      HTTP/1.1 #{status} Internal Server Error
      Content-Type: text/plain
      Content-Length: #{content.length}
    END

    headers.gsub("\n", "\r\n") + "\r\n" + content
  end

  private

  def status
    @status ||=
      if exception
        500
      else
        200
      end
  end

  def content
    @content ||=
      if exception
        "#{exception.class}: #{exception.message}\n#{exception.backtrace.join("\n")}"
      else
        "Hello World!"
      end
  end
end
