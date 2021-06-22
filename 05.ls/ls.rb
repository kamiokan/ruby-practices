#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'etc'

ARRAY_TO_RWX = %w[--- --x -w- -wx r-- r-x rw- rwx].freeze

def main
  options = ARGV.getopts('a', 'l', 'r')
  file_names = options['a'] ? Dir.glob('*', File::FNM_DOTMATCH) : Dir.glob('*')
  file_names = file_names.sort
  file_names = file_names.reverse if options['r']
  if options['l']
    files_with_info = file_names.map do |file_name|
      stat = File.stat(file_name)
      file_info = ''
      file_info += to_file_type_char(stat.ftype)
      file_info += "#{convert_int_to_rwx(stat)}  "
      file_info += "#{format('%2d', stat.nlink)} "
      file_info += "#{Etc.getpwuid(stat.uid).name}  "
      file_info += "#{Etc.getgrgid(stat.gid).name} "
      file_info += "#{format('%5d', stat.size)} "
      file_info += "#{stat.mtime.strftime('%_m %e %H:%M')} "
      file_info += file_name
      file_info
    end
    puts files_with_info
  else
    display(file_names)
  end
end

# ファイルタイプを取得する
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

# ファイルパーミッション数字をwrxに変換する
def convert_int_to_rwx(stat)
  number = stat.mode.to_s(8).slice(3, 5)
  result = ''
  (0..2).each do |i|
    result += ARRAY_TO_RWX[number.slice(i).to_i]
  end
  result
end

# ファイル名の最大の長さを取得する
def get_longest_size(files)
  longest_size = 0
  files.each do |f|
    longest_size = f.size if f.size > longest_size
  end
  longest_size
end

# 表示する
def display(file_names)
  step = (file_names.size / 3.0).ceil
  arithmetic_progression = []

  i = 0
  while i < step
    arithmetic_progression << [file_names[i], file_names[i + step], file_names[i + step * 2]]
    i += 1
  end

  longest_file_name_size = get_longest_size(file_names)
  arithmetic_progression.each do |arr|
    arr.each_with_index do |n, index|
      unless n.nil?
        printf("%#-#{longest_file_name_size}s", n)
        print ' ' * 5
      end
      puts if index == 2
    end
  end
end

main
