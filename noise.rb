#!/usr/bin/env ruby

require 'ruby-progressbar'
require 'streamio-ffmpeg'

min_bitrate = 600
max_bitrate = 1200
min_noise = 1
max_noise = 20
BEGIN {
  default_copies = 3
}
copies = ARGV[2].to_i || default_copies
black = RandomSymbolGenerator.new('\|/|')
white = RandomSymbolGenerator.new('-')

progressbar = ProgressBar.create(
  title: "0/#{copies}",
  format: '%t %a [%B] %J%% %f  ',
  progress_mark: "=",
  remainder_mark: " ",
  starting_at: 0.0,
  total: copies.to_f
)

input_filename = ARGV[0]
input_file = FFMPEG::Movie.new(input_filename)
output_prefix = ARGV[1] || File.basename(input_filename, ".*")

copies.times do |i|
  video_bitrate = rand(min_bitrate...max_bitrate)
  noise = rand(min_noise...max_noise)

  ffmpeg_options = {
    video_bitrate: video_bitrate,
    custom: %W[-vf noise=alls=#{noise}:allf=t+u]
  }

  output_file = "#{output_prefix}#{i + 1}.mp4"
  progressbar.title = "#{i + 1}/#{copies}"
  input_file.transcode(output_file, ffmpeg_options) do |progress|
    print "\r\033[K"
    progressbar.progress_mark = black.get
    progressbar.remainder_mark = white.get
    progressbar.progress = progress + i
  end

  print "\r\033[K"
end

BEGIN {
  if ARGV[0].nil?
    STDERR.puts "Usage: input_filename [output_prefix] [copies]"
    STDERR.puts "Default [output_prefix] is input_filename without extension"
    STDERR.puts "Default [copies] is #{default_copies}"
    exit(1)
  end

  if !File.exist?(ARGV[0])
    STDERR.puts "Error: input file does not exist"
    exit 1
  end
  class RandomSymbolGenerator
    attr_reader :symbols, :queue

    def initialize(data = nil)
      @symbols = (Array(data || %w[! @ # $ % ^ & *]).join.chars.map{ |x| x == '\\' ? '\\\\' : x })
      # map { |x| x == '\\' ? '\\\\' : x }
      # this expression added as hotfix - instance of ProgressBar prints '\\' as '\'
      # so, i just repeated it)
      @queue = symbols.dup
    end

    def get
      symbol = queue.shift
      queue << symbol
      symbol
    end
  end
}
