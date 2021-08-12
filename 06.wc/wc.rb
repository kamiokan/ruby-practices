#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def main
  options = ARGV.getopts('l')
  file_paths = ARGV

  case file_paths.count
  when 0
    text = $stdin.read
    print text.count('\n').to_s.rjust(8)
    print text.split(/[\s+,\n]/).size.to_s.rjust(8)
    puts text.bytesize.to_s.rjust(8)
  when 1
    file_path = file_paths[0]
    if options['l']
      print format('%8d', count_lines(file_path))
      puts " #{file_path}"
    else
      print format('%8d', count_lines(file_path))
      print format('%8d', count_words(file_path))
      print format('%8d', count_bytes(file_path))
      puts " #{file_path}"
    end
  else
    total_count_lines = 0
    total_count_words = 0
    total_count_bytes = 0
    file_paths.each do |file_path|
      if options['l']
        total_count_lines += count_lines(file_path)
        print format('%8d', count_lines(file_path))
        puts " #{file_path}"
      else
        total_count_lines += count_lines(file_path)
        total_count_words += count_words(file_path)
        total_count_bytes += count_bytes(file_path)
        print format('%8d', count_lines(file_path))
        print format('%8d', count_words(file_path))
        print format('%8d', count_bytes(file_path))
        puts " #{file_path}"
      end
    end
    if options['l']
      print format('%8d', total_count_lines)
      puts ' total'
    else
      print format('%8d', total_count_lines)
      print format('%8d', total_count_words)
      print format('%8d', total_count_bytes)
      puts ' total'
    end
  end
end

def count_lines(file_path)
  File.read(file_path).lines.count
end

def count_words(file_path)
  strings = File.read(file_path)
  strings.split(/[\s+,\n]/).size
end

def count_bytes(file_path)
  File.stat(file_path).size
end

main
