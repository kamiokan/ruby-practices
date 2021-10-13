#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def main
  options = ARGV.getopts('l')
  file_paths = ARGV

  case file_paths.count
  when 0
    text = $stdin.read
    display_zero_argument(text, options)
  when 1
    file_path = file_paths[0]
    display_some_arguments(file_path, options)
  else
    total_count = { lines: 0, words: 0, bytes: 0 }
    file_paths.each do |f|
      total_count[:lines] += count_lines(f)
      total_count[:words] += count_words(f)
      total_count[:bytes] += count_bytes(f)
      display_some_arguments(f, options)
    end
    display_total_count(total_count, options)
  end
end

def count_lines(file_path)
  File.read(file_path).lines.count
end

def count_words(file_path)
  File.read(file_path).split(/\s+/).size
end

def count_bytes(file_path)
  File.stat(file_path).size
end

def display_zero_argument(text, options)
  print text.lines.count.to_s.rjust(8)
  return if options['l']

  print text.split(/\s+/).size.to_s.rjust(8)
  puts text.bytesize.to_s.rjust(8)
end

def display_some_arguments(file_path, options)
  print count_lines(file_path).to_s.rjust(8)
  unless options['l']
    print count_words(file_path).to_s.rjust(8)
    print count_bytes(file_path).to_s.rjust(8)
  end
  puts " #{file_path}"
end

def display_total_count(total_count, options)
  print total_count[:lines].to_s.rjust(8)
  unless options['l']
    print total_count[:words].to_s.rjust(8)
    print total_count[:bytes].to_s.rjust(8)
  end
  puts ' total'
end

main
