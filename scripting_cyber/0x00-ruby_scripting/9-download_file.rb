require 'open-uri'
require 'uri'
require 'fileutils'

if ARGV.length != 2
  puts "Usage: #{File.basename($0)} URL LOCAL_FILE_PATH"
  exit
end

url = ARGV[0]
local_path = ARGV[1]

puts "Downloading file from #{url}..."

begin
  target_dir = File.dirname(local_path)
  FileUtils.mkdir_p(target_dir) unless Dir.exist?(target_dir)

  URI.open(url) do |remote_file|
    File.open(local_path, 'wb') do |local_file|
      local_file.write(remote_file.read)
    end
  end

  puts "File downloaded and saved to #{local_path}."
rescue OpenURI::HTTPError => e
  $stderr.puts "HTTP error: #{e.message}"
  exit 1
rescue SocketError => e
  $stderr.puts "Connection error: #{e.message}"
  exit 1
rescue Errno::EACCES => e
  $stderr.puts "Permission denied: #{e.message}"
  exit 1
rescue StandardError => e
  $stderr.puts "Error: #{e.message}"
  exit 1
end
