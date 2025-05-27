# Toy HTTP server inspired by Rebuilding HTTP by Noah Gibbs
#
# Run it with `bin/server` or `bin/s`
# Then visit http://localhost:4321 in your browser or run `curl -v http://localhost:4000`

require "socket"
require_relative "response"
require_relative "request"

class Server
  PORT = 4000
  START_MESSAGE = "Server is running"

  def start
    server = TCPServer.new(PORT)
    puts "#{START_MESSAGE} on port #{PORT}..."

    loop do
      client = server.accept
      request = Request.new(client)
      puts request
      client.write(Response.new(request).to_s)
    rescue => e
      client&.write(Response.new(exception: e).to_s)
      raise e
    ensure
      client&.close
    end
  end
end
