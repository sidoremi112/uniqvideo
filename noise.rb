#!/usr/bin/env ruby
require 'ruby-progressbar'
require 'streamio-ffmpeg'

input_filename = ARGV[0]
output_prefix = ARGV[1] || File.basename(input_filename, ".*")
if !File.exist?(input_filename)
  STDERR.puts "Error: input file does not exist"
  exit 1
end

input_file = FFMPEG::Movie.new(input_filename)

min_bitrate = 600
max_bitrate = 1200
min_noise = 1
max_noise = 20
default_copies = 3
copies = ARGV[2].to_i || default_copies

copies.times do |i|
  video_bitrate = rand(min_bitrate...max_bitrate)
  noise = rand(min_noise...max_noise)

  ffmpeg_options = {
    video_bitrate: video_bitrate,
    custom: %W[-vf noise=alls=#{noise}:allf=t+u]
  }

  progressbar = ProgressBar.create(
    title: "#{i + 1}/#{copies}",
    format: '%t: %f [%B] %P%%     ',
    progress_mark: "=",
    remainder_mark: " ",
    starting_at: 0.0,
    total: 1.0
  )

  output_file = "#{output_prefix}#{i + 1}.mp4"
  input_file.transcode(output_file, ffmpeg_options) do |progress|
    progressbar.progress = progress
  end

  print "\r\033[K"
end
