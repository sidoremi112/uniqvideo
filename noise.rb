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

progressbar = ProgressBar.create(
  title: "0/#{copies}",
  format: '%t %a [%B] %J%% %f  ',
  progress_mark: "=",
  remainder_mark: " ",
  starting_at: 0.0,
  total: copies.to_f
)

copies.times do |i|
  video_bitrate = rand(min_bitrate...max_bitrate)
  noise = rand(min_noise...max_noise)

  ffmpeg_options = {
  video_bitrate: video_bitrate,
  custom: %W[-vf noise=alls=#{noise}:allf=t+u]
  }

  output_file = "#{output_prefix}#{i + 1}.mp4"
  progressbar.title = "#{i+1}/#{copies}"
  input_file.transcode(output_file, ffmpeg_options) do |progress|
    progressbar.progress = progress + i
    progressbar.progress_mark = %W(= # $ % &).sample
  end

  print "\r\033[K"
end
