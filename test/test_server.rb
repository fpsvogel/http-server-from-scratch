require "open3"
require_relative "../lib/server"

class TestServer
  private attr_reader :pid, :stdout, :stderr

  def kill
    stdout&.close
    stderr&.close
    Process.kill(9, pid)
  rescue
  end

  def start
    # Start the server process with output buffering disabled, and with a port
    # different from the default to avoid a conflict with a running server.
    stdin, @stdout, @stderr, wait_thread =
      Open3.popen3("ruby -e 'STDOUT.sync = true; STDERR.sync = true; ARGV[0] = #{Server::DEFAULT_PORT - 1}; load \"./bin/server\"'")
    stdin.close
    @pid = wait_thread.pid

    # On termination of the this process (for tests), kill the server process.
    # Prevents the server from running indefinitely if a #teardown doesn't run.
    at_exit do
      kill
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
