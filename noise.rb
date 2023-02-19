#!/usr/bin/env ruby
# frozen_string_literal: true

require 'streamio-ffmpeg'

# Get the input filename from the first command line argument
input_filename = ARGV[0]

# Check if input file exists
if !File.file?(input_filename)
  puts "Error: Input file '#{input_filename}' not found"
  exit(1)
end

# Extract the input filename without extension
prefix = File.basename(input_filename, ".*")

# Get the output prefix from the second command line argument, or use the input filename without extension as the default
output_prefix = ARGV[1] || prefix

# Get the number of output copies from the third command line argument, or use 4 as the default
copies = (ARGV[2] || 4).to_i

# Define the output file format
output_format = '.mp4'

# Define the FFmpeg options as a Hash
ffmpeg_options = {
  video_bitrate: 600,
  custom: ['-vf', "noise=alls=#{rand(1...20)}:allf=t+u"]
}

# Load the original video file
input_file = FFMPEG::Movie.new(input_filename)

# Generate the output files with the specified options
copies.times do |i|
  output_file = output_prefix + "_#{i + 1}" + output_format
  input_file.transcode(output_file, ffmpeg_options) do |progress|
    print "\r\033[K#{sprintf("%0.2f%%", progress * 100)}"
  end
end

# Clear the current line without printing a newline character
print "\r\033[K"
