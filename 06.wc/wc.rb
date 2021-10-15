#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def main
  options = ARGV.getopts('l')
  file_paths = ARGV

  case file_paths.count
  when 0
    text = $stdin.read
    display_arguments(text, options)
    puts
  when 1
    file_path = file_paths[0]
    text = File.read(file_path)
    display_arguments(text, options)
    puts " #{file_path}"
  else
    total_count = { lines: 0, words: 0, bytes: 0 }
    file_paths.each do |f|
      text = File.read(f)
      count_arguments(text, total_count)
      display_arguments(text, options)
      puts " #{f}"
    end
    display_total_count(total_count, options)
  end
end

def display_arguments(text, options)
  print text.lines.count.to_s.rjust(8)
  return if options['l']

  print text.split(/\s+/).size.to_s.rjust(8)
  print text.bytesize.to_s.rjust(8)
end

def count_arguments(text, total_count)
  total_count[:lines] += text.lines.count
  total_count[:words] += text.split(/\s+/).size
  total_count[:bytes] += text.bytesize
  total_count
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
