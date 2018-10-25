#!/usr/bin/env ruby
# frozen_string_literal: true

PWD = Dir.pwd

def sys(cmd)
  puts cmd
  system(cmd)
end

TOP = ARGV.empty? ? %w[crystal elixir go java ruby rust] : ARGV
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
