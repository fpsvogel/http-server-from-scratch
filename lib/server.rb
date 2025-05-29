# Toy HTTP server inspired by Rebuilding HTTP by Noah Gibbs
#
# Run it with `bin/server` or `bin/s`
# Then visit http://localhost:4321 in your browser or run `curl -v http://localhost:4000`

require "socket"
require_relative "live_reloader"
require_relative "request"
require_relative "response"

class Server
  PORT = 4000
  START_MESSAGE = "Server is running"

  def start
    server = TCPServer.new(PORT)
    puts "#{START_MESSAGE} on port #{PORT}..."

    LiveReloader.start

    loop do
      client = server.accept
      request = Request.new(client)
      puts request
      puts
      response = Response.new(
        "Hello Response!",
        headers: {"Content-Language" => "en"}
      )
      puts response
      puts
      client.write(response.to_s)
    rescue Request::InvalidRequestError => e
      response = Response.new(
        "#{e.class}: #{e.message}\n#{e.backtrace.join("\n")}",
        status: 400,
        message: "Bad Request"
      )
      client&.write(response.to_s)
      puts response
      puts
      next
    rescue => e
      response = Response.new(
        "#{e.class}: #{e.message}\n#{e.backtrace.join("\n")}",
        status: 500,
        message: "Internal Server Error"
      )
      client&.write(response.to_s)
      raise e
    ensure
      client&.close
    end
  end
end
