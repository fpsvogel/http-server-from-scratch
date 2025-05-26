# Minimal HTTP server from Chapter 1 of Rebuilding HTTP by Noah Gibbs
#
# Run it with `ruby start.rb`
# Then visit http://localhost:4321 in your browser or run `curl -v http://localhost:4321`

require "socket"

class Server
  PORT = 4000
  START_MESSAGE = "Server is running"
  RESPONSE_CONTENT = "Hello World!"
  HEADERS = <<~END
    HTTP/1.1 200 OK
    Content-Type: text/plain
    Content-Length: #{RESPONSE_CONTENT.length}
  END
  RESPONSE = HEADERS.gsub("\n", "\r\n") + "\r\n" + RESPONSE_CONTENT

  def start
    server = TCPServer.new(PORT)
    puts "#{START_MESSAGE} on port #{PORT}..."

    loop do
      client = server.accept
      puts "Got a connection!"
      puts client.gets.inspect
      client.write(RESPONSE)
      client.close
    end
  end
end
