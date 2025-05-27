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
    output = `curl -s http://localhost:4000 2>&1`
    expected = "Hello World!"

    assert_equal expected, output.strip,
      "Server did not return expected response. #{@server.error_message}"
  end
end
