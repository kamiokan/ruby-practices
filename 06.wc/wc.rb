#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def main
  options = ARGV.getopts('l')
  file_paths = ARGV

  case file_paths.count
  when 0
    text = $stdin.read
    print text.lines.count.to_s.rjust(8)
    print text.split(/\s+/).size.to_s.rjust(8)
    puts text.bytesize.to_s.rjust(8)
  when 1
    file_path = file_paths[0]
    if options['l']
      print count_lines(file_path).to_s.rjust(8)
      puts " #{file_path}"
    else
      print count_lines(file_path).to_s.rjust(8)
      print count_words(file_path).to_s.rjust(8)
      print count_bytes(file_path).to_s.rjust(8)
      puts " #{file_path}"
    end
  else
    total_count_lines = 0
    total_count_words = 0
    total_count_bytes = 0
    file_paths.each do |file_path|
      if options['l']
        total_count_lines += count_lines(file_path)
        print count_lines(file_path).to_s.rjust(8)
        puts " #{file_path}"
      else
        total_count_lines += count_lines(file_path)
        total_count_words += count_words(file_path)
        total_count_bytes += count_bytes(file_path)
        print count_lines(file_path).to_s.rjust(8)
        print count_words(file_path).to_s.rjust(8)
        print count_bytes(file_path).to_s.rjust(8)
        puts " #{file_path}"
      end
    end
    if options['l']
      print total_count_lines.to_s.rjust(8)
      puts ' total'
    else
      print total_count_lines.to_s.rjust(8)
      print total_count_words.to_s.rjust(8)
      print total_count_bytes.to_s.rjust(8)
      puts ' total'
    end
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

main
