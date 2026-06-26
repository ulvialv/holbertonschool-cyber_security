require 'net/http'
require 'uri'
require 'json'

def post_request(url, body_params)
  begin
    uri = URI.parse(url)
  rescue URI::InvalidURIError => e
    $stderr.puts "Error: invalid URL '#{url}': #{e.message}"
    return
  end

  begin
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = (uri.scheme == 'https')

    request = Net::HTTP::Post.new(uri.path, {'Content-Type' => 'application/json'})
    request.body = body_params.to_json

    response = http.request(request)
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
    parsed_response = JSON.parse(response.body)
    if parsed_response.empty?
      puts "{}"
    else
      puts JSON.pretty_generate(parsed_response)
    end
  rescue JSON::ParserError
    puts response.body
  end
end
