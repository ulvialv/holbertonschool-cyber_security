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
rescue => e
  puts "An error occurred: #{e.message}"
end
