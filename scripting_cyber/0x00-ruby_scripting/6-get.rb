require 'net/http'
require 'uri'
require 'json'

def get_request(url)
  begin
    uri = URI.parse(url)
  rescue URI::InvalidURIError => e
    $stderr.puts "Error: invalid URL '#{url}': #{e.message}"
    return
  end

  begin
    response = Net::HTTP.get_response(uri)
  rescue SocketError => e
    $stderr.puts "Error: could not connect to '#{url}': #{e.message}"
    return
  rescue Net::OpenTimeout, Net::ReadTimeout => e
    $stderr.puts "Error: request timed out: #{e.message}"
    return
  end

  puts "Response status: #{response.code} #{response.message}"
  puts "Response body:"
  begin
    puts JSON.pretty_generate(JSON.parse(response.body))
  rescue JSON::ParserError
    puts response.body
  end
end
