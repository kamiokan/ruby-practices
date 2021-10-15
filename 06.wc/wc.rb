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
    puts
  when 1
    file_path = file_paths[0]
    text = File.read(file_path)
    display_some_arguments(text, options)
    puts " #{file_path}"
  else
    total_count = { lines: 0, words: 0, bytes: 0 }
    file_paths.each do |f|
      text = File.read(f)
      total_count[:lines] += count_lines(text)
      total_count[:words] += count_words(text)
      total_count[:bytes] += count_bytes(text)
      display_some_arguments(text, options)
      puts " #{f}"
    end
    display_total_count(total_count, options)
  end
end

def count_lines(text)
  text.lines.count
end

def count_words(text)
  text.split(/\s+/).size
end

def count_bytes(text)
  text.bytesize
end

def display_zero_argument(text, options)
  print text.lines.count.to_s.rjust(8)
  return if options['l']

  print text.split(/\s+/).size.to_s.rjust(8)
  print text.bytesize.to_s.rjust(8)
end

def display_some_arguments(text, options)
  print text.lines.count.to_s.rjust(8)
  return if options['l']

  print text.split(/\s+/).size.to_s.rjust(8)
  print text.bytesize.to_s.rjust(8)
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
