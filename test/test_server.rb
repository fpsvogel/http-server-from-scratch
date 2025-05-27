require "open3"
require_relative "../lib/server"

class TestServer
  attr_reader :server_pid, :stdout, :stderr

  def kill
    stdout&.close
    stderr&.close
    Process.kill(9, server_pid)
  rescue
  end

  def start
    # Start the server process with output buffering disabled.
    stdin, @stdout, @stderr, wait_thread =
      Open3.popen3("ruby -e 'STDOUT.sync = true; STDERR.sync = true; load \"./bin/server\"'")
    stdin.close
    @server_pid = wait_thread.pid

    # On termination of the this process (for tests), kill the server process.
    # Prevents the server from running indefinitely if a #teardown doesn't run.
    at_exit do
      Process.kill(9, server_pid)
    rescue
    end

    # Wait for the server to start up.
    loop do
      break if stdout.readline.include?(Server::START_MESSAGE)
    rescue EOFError
      raise "End of server stdout: server did not start, or terminated unexpectedly."
    end

    self
  end

  def error_message
    if IO.select([stderr], nil, nil, 0)
      begin
        "Server raised an error:\n#{stderr.read_nonblock(4096)}".strip
      rescue
        "Error reading from stderr."
      end
    else
      "No error output from server."
    end
  end
end
