#!/usr/bin/env ruby
# frozen_string_literal: true

PWD = Dir.pwd

def which(cmd)
  w = `which #{cmd}`.chomp
  w.empty? ? cmd : w
end

CHECK_MESSAGES = {
  exists: 'not found',
  directory: 'is not a directory',
  readable: 'is not readable',
  executable: 'is not executable'
}.freeze

def assert_path(path, *checks)
  checks.each do |check|
    next if eval("File.#{check}?(path)", nil, __FILE__, __LINE__)
    prefix = if checks.include?(:executable)
               'Command'
             elsif checks.include?(:directory)
               'Directory'
             else
               'File'
             end
    puts "#{prefix} \"#{path}\" #{CHECK_MESSAGES[check]}!"
    puts "\a"
    exit 1
  end
end

def sys(cmd)
  puts cmd
  system(cmd)
end

TOP = %w[crystal elixir go java ruby]
TOP.each do |top|
  Dir.children(top).each do |child|
    path = File.join(PWD, top, child)
    next unless File.directory?(path)
    if File.file?(File.join(path, 'Dockerfile'))
      Dir.chdir(path) do
        puts "cd #{path}"
        sys(%(docker build -t #{child} .))
      end
    else
      puts %(No `Dockerfile` found in "#{path}")
    end
  end
end
