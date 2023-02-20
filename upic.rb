#!/usr/bin/env ruby
BEGIN{
  def calculate_downscale_size(max, width, height = nil)
    unless max.is_a?(Numeric) && max > 0
      raise ArgumentError, "max must be a positive number"
    end
    unless width.is_a?(Numeric) && width > 0
      raise ArgumentError, "width must be a positive number"
    end
    unless height.is_a?(Numeric) && height > 0 || height.nil?
      raise ArgumentError, "height must be a positive number" unless height.nil?
    end

    max = max.to_i if max.is_a?(Float) && max % 1 == 0

    return [max, max] if width == height || height.nil?

    if width > height
      result = height.to_f / width * max
      result = result.to_i if result % 1 == 0
      [max, result]
    else
      result = width.to_f / height * max
      result = result.to_i if result % 1 == 0
      [result, max]
    end
  end
}
