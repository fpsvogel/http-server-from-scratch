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
    expected = <<~END
      Hello World!
      GET / HTTP/1.1
      Host: localhost:4000
      User-Agent: curl/8.7.1
      Accept: */*
    END

    assert_equal expected.strip, output.strip,
      "Server did not return expected response. #{@server.error_message}"
  end
end
