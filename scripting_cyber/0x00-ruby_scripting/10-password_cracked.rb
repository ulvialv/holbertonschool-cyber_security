require 'digest'

if ARGV.length != 2
  puts "Usage: 10-password_cracked.rb HASHED_PASSWORD DICTIONARY_FILE"
  exit
end

hashed_password = ARGV[0].downcase
dictionary_file = ARGV[1]

unless File.exist?(dictionary_file)
  $stderr.puts "Error: dictionary file '#{dictionary_file}' not found"
  exit 1
end

begin
  File.foreach(dictionary_file) do |line|
    word = line.chomp
    hashed_word = Digest::SHA256.hexdigest(word)

    if hashed_word == hashed_password
      puts "Password found: #{word}"
      exit
    end
  end
rescue Errno::EACCES
  $stderr.puts "Error: permission denied reading '#{dictionary_file}'"
  exit 1
end

puts "Password not found in dictionary."
