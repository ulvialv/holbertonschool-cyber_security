require 'json'

def merge_json_files(file1_path, file2_path)
  [file1_path, file2_path].each do |path|
    unless File.exist?(path)
      $stderr.puts "Error: file '#{path}' not found"
      return
    end
  end

  begin
    data1 = JSON.parse(File.read(file1_path))
    data2 = JSON.parse(File.read(file2_path))
  rescue JSON::ParserError => e
    $stderr.puts "Error: invalid JSON: #{e.message}"
    return
  rescue Errno::EACCES => e
    $stderr.puts "Error: permission denied: #{e.message}"
    return
  end

  merged_data = data2 + data1

  begin
    File.open(file2_path, 'w') do |f|
      f.write(JSON.pretty_generate(merged_data))
    end
  rescue Errno::EACCES
    $stderr.puts "Error: permission denied writing to '#{file2_path}'"
    return
  end
  puts "Merged JSON written to file.json"
end
