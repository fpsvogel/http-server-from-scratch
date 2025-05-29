# Inspired by https://github.com/noahgibbs/testing_rebuilding_http

require_relative "test_helper"
require_relative "test_server"

class ServerTest < Minitest::Test
  def setup
    @server = TestServer.new.start
  end

  def teardown
    @server.kill
  end

  def test_200_response
    output = `curl -s -v http://localhost:3999 2>&1`
    expected = <<~END
      * Host localhost:3999 was resolved.
      * IPv6: ::1
      * IPv4: 127.0.0.1
      *   Trying [::1]:3999...
      * Connected to localhost (::1) port 3999
      > GET / HTTP/1.1\r
      > Host: localhost:3999\r
      > User-Agent: curl/8.7.1\r
      > Accept: */*\r
      > \r
      * Request completely sent off
      < HTTP/1.1 200 OK\r
      < Content-Type: text/html\r
      < Content-Length: 15\r
      < Content-Language: en\r
      < \r
      { [15 bytes data]
      * Connection #0 to host localhost left intact
      Hello Response!
    END

    assert_equal expected.strip, output.strip,
      "Server did not return expected response. #{@server.error_message}"
  end
end
