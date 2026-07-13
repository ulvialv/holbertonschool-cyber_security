#!/usr/bin/env ruby
require 'optparse'

TASKS_FILE = 'tasks.txt'

def add_task(task)
  begin
    File.open(TASKS_FILE, 'a') do |file|
      file.puts(task)
    end
    puts "Task '#{task}' added."
  rescue Errno::EACCES
    $stderr.puts "Error: permission denied writing to '#{TASKS_FILE}'"
  rescue IOError => e
    $stderr.puts "Error: could not write task: #{e.message}"
  end
end

def list_tasks
  if File.exist?(TASKS_FILE) && !File.zero?(TASKS_FILE)
    puts "Tasks:"
    File.readlines(TASKS_FILE).each_with_index do |line, index|
      puts "#{index + 1}. #{line.chomp}"
    end
  end
end

def remove_task(index)
  return unless File.exist?(TASKS_FILE)

  tasks = File.readlines(TASKS_FILE)
  task_index = index.to_i - 1
  
  if task_index >= 0 && task_index < tasks.length
    removed_task = tasks.delete_at(task_index).chomp
    File.open(TASKS_FILE, 'w') do |file|
      tasks.each { |task| file.write(task) }
    end
    puts "Task '#{removed_task}' removed."
  else
    $stderr.puts "Error: invalid task index '#{index}' (valid range: 1-#{tasks.length})"
  end
end

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: cli.rb [options]"

  opts.on("-a", "--add TASK", "Add a new task") do |task|
    options[:add] = task
  end

  opts.on("-l", "--list", "List all tasks") do
    options[:list] = true
  end

  opts.on("-r", "--remove INDEX", "Remove a task by index") do |index|
    options[:remove] = index
  end

  opts.on("-h", "--help", "Show help") do
    puts opts
    exit
  end
end.parse!

if options[:add]
  add_task(options[:add])
elsif options[:list]
  list_tasks
elsif options[:remove]
  remove_task(options[:remove])
end
