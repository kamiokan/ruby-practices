#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'etc'
require 'io/console'

ARRAY_TO_RWX = %w[--- --x -w- -wx r-- r-x rw- rwx].freeze
COLUMN_COUNT = 3

def main
  options = ARGV.getopts('a', 'l', 'r')
  file_names = options['a'] ? Dir.glob('*', File::FNM_DOTMATCH) : Dir.glob('*')
  file_names = file_names.sort
  file_names = file_names.reverse if options['r']
  if options['l']
    display_with_l_option(file_names)
  else
    display(file_names)
  end
end

def to_file_type_char(type_name)
  case type_name
  when 'directory'
    'd'
  when 'file'
    '-'
  when 'characterSpecial'
    'c'
  when 'blockSpecial'
    'b'
  when 'fifo'
    'p'
  when 'link'
    'l'
  when 'socket'
    's'
  else
    '?'
  end
end

def convert_int_to_rwx(stat)
  number = stat.mode.to_s(8).slice(-3, 3)
  result = ''
  (0..2).each do |i|
    result += ARRAY_TO_RWX[number[i].to_i]
  end
  result
end

def display(file_names)
  step = (file_names.size / COLUMN_COUNT.to_f).ceil
  arithmetic_progression = Array.new(step) do |i|
    Array.new(COLUMN_COUNT) do |j|
      file_names[i + step * j]
    end
  end

  longest_file_name_size = file_names.max_by(&:length).size
  console_width = IO.console.winsize[1]
  arithmetic_progression.each do |file_names_arr|
    file_names_arr.each_with_index do |file_name, index|
      unless file_name.nil?
        display_width = [(longest_file_name_size + 1), (console_width / COLUMN_COUNT)].max
        print file_name.ljust(display_width)
      end
      puts if index == COLUMN_COUNT - 1
    end
  end
end

def display_with_l_option(file_names)
  blocks = 0
  files_with_info = file_names.map do |file_name|
    stat = File.stat(file_name)
    blocks += stat.blocks
    file_info = ''
    file_info += to_file_type_char(stat.ftype)
    file_info += "#{convert_int_to_rwx(stat)} "
    file_info += "#{stat.nlink.to_s.rjust(2)} "
    file_info += "#{Etc.getpwuid(stat.uid).name}  "
    file_info += "#{Etc.getgrgid(stat.gid).name} "
    file_info += "#{stat.size.to_s.rjust(5)} "
    file_info += "#{stat.mtime.strftime('%_m %e %H:%M')} "
    file_info += file_name
    file_info
  end
  puts "total #{blocks}"
  puts files_with_info
end

main
