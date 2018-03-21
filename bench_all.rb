#!/usr/bin/env ruby
# frozen_string_literal: true

require 'csv'
require 'json'
require 'net/http'
require 'net_http_unix'
require 'socket'

TARGETS = {
  'java-jersey-docker' => 8080,
  'ruby-sinatra-docker' => 4567,
  'go-api-docker' => 8080,
  'elixir-maru-docker' => 8000,
  'crystal-kemal-docker' => 3000
}.freeze

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

NONCE = Process.pid
SLEEP = 0.5
REQUESTS = 10000
CONCURRENCY = 20
URL = 'http://localhost:8000/hello?who=world'
AB = which('ab')
assert_path AB, :exists, :readable, :executable

def process_is_running?(pid)
  system("ps #{pid}")
end

DockerImageInfo = Struct.new :size

def docker_image_info(image_name)
  req = Net::HTTP::Get.new("/images/#{image_name}/json")
  client = NetX::HTTPUnix.new('unix:///var/run/docker.sock')
  resp = client.request(req)
  json = JSON.parse(resp.body)
  DockerImageInfo.new json['Size']
end

DockerStats = Struct.new :cpu_usage, :system_cpu_usage, :memory_usage, :memory_max_usage

def docker_stats(container_name)
  req = Net::HTTP::Get.new("/containers/#{container_name}/stats?stream=false")
  client = NetX::HTTPUnix.new('unix:///var/run/docker.sock')
  resp = client.request(req)
  json = JSON.parse(resp.body)
  DockerStats.new json['cpu_stats']['cpu_usage']['total_usage'],
                  json['cpu_stats']['system_cpu_usage'],
                  json['memory_stats']['usage'],
                  json['memory_stats']['max_usage']
end

def run_ab_and_wait(container_name)
  ab_command = %(#{AB} -n #{REQUESTS} -c #{CONCURRENCY} "#{URL}")
  puts ab_command
  pid = spawn(ab_command)
  return unless pid
  pthread = Process.detach(pid)
  # while process_is_running?(pid)
  stats = []
  while pthread.alive?
    stats << docker_stats(container_name)
    sleep(SLEEP)
  end
  stats
ensure
  `docker stop #{container_name}`
end

ReportedStats = Struct.new :cpu_percent, :memory_usage, :memory_max_usage

def benchmark(name, port)
  container_name = "#{name}-#{NONCE}"
  docker_run_cmd = "docker run --rm --name #{container_name} -p 8000:#{port} -d #{name}"
  puts docker_run_cmd
  exit 1 unless system(docker_run_cmd)
  # Gather baseline stats before load
  stats_before_load = docker_stats(container_name)
  stats_with_load = run_ab_and_wait(container_name)
  stats_with_load.unshift(stats_before_load).each_cons(2).map do |s0, s1|
    system_delta = (s1.system_cpu_usage - s0.system_cpu_usage).abs
    cpu_delta = (s1.cpu_usage - s0.cpu_usage)
    cpu_percent = system_delta > 0 ? Rational(cpu_delta, system_delta) : Rational(0, 0)
    ReportedStats.new cpu_percent, s1.memory_usage, s1.memory_max_usage
  end
end

module Enumerable
  def average
    sum / count
  end
end

def group_digits(number)
  number.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse
end

def humanize(bytes)
  case
  when bytes < 10_000
    group_digits(bytes)
  when bytes < 1_000_000
    decimal = 100 * (bytes % 1024) / 1024
    "#{group_digits(bytes / 1024)}.#{decimal} KB"
  when bytes < 1_000_000_000
    decimal = 100 * (bytes % 1048576) / 1048576
    "#{group_digits(bytes / 1048576)}.#{decimal} MB"
  else
    decimal = 100 * (bytes % 1073741824) / 1073741824
    "#{group_digits(bytes / 1073741824)}.#{decimal} GB"
  end
end

report = [%w[CONTAINER IMAGE_SIZE CPU AVERAGE_RAM MAX_RAM SAMPLES]]
TARGETS.each do |name, port|
  stats = benchmark(name, port)
  image_size = docker_image_info(name).size
  average_cpu = '%0.2f%%' % (100 * stats.map(&:cpu_percent).average).to_f
  average_ram = humanize(stats.map(&:memory_usage).average)
  max_ram = humanize(stats.map(&:memory_max_usage).max)
  samples = stats.count - 1
  puts "Average CPU: #{average_cpu}"
  puts "Average RAM: #{average_ram}"
  puts "Max RAM: #{max_ram}"
  report << [name, humanize(image_size), average_cpu, average_ram, max_ram, samples]
end

report.each do |row|
  p row
end

def pretty_print(report)
  max_column_lengths = report.transpose.map do |values|
    values.map {|v| v.to_s.length}.max
  end
  mapped = report.map do |row|
    zipped = max_column_lengths.zip(row)
    width, first = zipped.shift
    a = [first]
    a << ' ' * (width + 2 - first.to_s.length)
    zipped.each do |width, v|
      s = v.to_s
      a << ' ' * (width + 2 - s.length)
      a << s
    end
    a
  end
  mapped.each do |m|
    puts m.join
  end
end

pretty_print(report)
