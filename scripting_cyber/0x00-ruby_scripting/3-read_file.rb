require 'json'

def count_user_ids(path)
  unless File.exist?(path)
    $stderr.puts "Error: file '#{path}' not found"
    return
  end

  begin
    file = File.read(path)
    data = JSON.parse(file)
  rescue JSON::ParserError => e
    $stderr.puts "Error: invalid JSON in '#{path}': #{e.message}"
    return
  rescue Errno::EACCES
    $stderr.puts "Error: permission denied reading '#{path}'"
    return
  end

  counts = Hash.new(0)

  data.each do |item|
    user_id = item['userId']
    counts[user_id] += 1
  end

  counts.sort_by { |user_id, _| user_id.to_i }.each do |user_id, count|
    puts "#{user_id}: #{count}"
  end
end
