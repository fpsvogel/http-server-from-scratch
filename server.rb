# Minimal HTTP server from Chapter 1 of Rebuilding HTTP by Noah Gibbs
# Run it with `ruby server.rb`, then visit http://localhost:4321 in your browser
# or run `curl -v http://localhost:4321`

# TODO: add a basic test. See the exercise on p. 28, and for inspiration see
# https://github.com/noahgibbs/testing_rebuilding_http

require "socket"

content = "Hello World!"
headers = <<~_
  HTTP/1.1 200 OK
  Content-Type: text/plain
  Content-Length: #{content.length}
_
response = headers.gsub("\n", "\r\n") + "\r\n" + content

server = TCPServer.new(4321)

loop do
  client = server.accept
  puts "Got a connection!"
  puts client.gets.inspect
  client.write(response)
  client.close
end
