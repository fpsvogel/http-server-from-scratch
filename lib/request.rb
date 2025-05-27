class Request
  def self.read(client)
    request = ""
    loop do
      line = client.gets
      request << line.chomp << "\n"
      return request if line.strip.empty?
    end
  end
end
