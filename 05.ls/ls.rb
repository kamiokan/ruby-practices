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
    files_with_info = []
    file_names.each do |file_name|
      stat = File.stat(file_name)
      file_info = ''
      file_info += select_file_type(stat.ftype)
      file_info += "#{convert_int_to_rwx(stat.mode.to_s(8).slice(3, 5), ARRAY_TO_RWX)}  "
      file_info += "#{format('%2d', stat.nlink.to_s)} "
      file_info += "#{Etc.getpwuid(stat.uid).name}  "
      file_info += "#{Etc.getgrgid(stat.gid).name} "
      file_info += "#{format('%5d', stat.size.to_s)} "
      file_info += "#{stat.mtime.strftime('%_m %e %H:%M')} "
      file_info += file_name
      files_with_info << file_info
    end
    file_names = files_with_info
  end

  # 出力する
  # オプション -l 無い時
  # 指定した列数で並べる
  if options['l']
    file_names.each do |f|
      puts f
    end
  else
    display(file_names)
  end
end

# ファイルタイプを取得する
def select_file_type(type_name)
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
def convert_int_to_rwx(number, array)
  array[number.slice(0).to_i] + array[number.slice(1).to_i] + array[number.slice(2).to_i]
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
def display(array)
  step = (array.size / 3.0).ceil
  res_array = []

  i = 0
  while i < step
    res_array << [array[i], array[i + step], array[i + step * 2]]
    i += 1
  end

  longest_file_name_size = get_longest_size(array)
  res_array.each do |arr|
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