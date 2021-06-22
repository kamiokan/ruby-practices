#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'etc'

ARRAY_TO_RWX = %w[--- --x -w- -wx r-- r-x rw- rwx].freeze

def main
  options = ARGV.getopts('a', 'l', 'r')

  file_names = []
  Dir.foreach('.') do |f|
    file_names << f
  end

  file_names.sort!

  # オプション -r 逆順にする
  file_names.reverse! if options['r']

  # オプション -a 無いとき
  # ドットで始まるファイルを取り除く
  file_names.delete_if { |f| /^\..*/ =~ f } unless options['a']

  # オプション -l
  # ファイル情報を追加する
  if options['l']
    files_with_info = []
    file_names.each do |f|
      s = File.stat(f)
      new_f = select_file_type(s.ftype)
      new_f += "#{convert_int_to_rwx(s.mode.to_s(8).slice(3, 5), ARRAY_TO_RWX)}  "
      new_f += "#{format('%2d', s.nlink.to_s)} "
      new_f += "#{Etc.getpwuid(s.uid).name}  "
      new_f += "#{Etc.getgrgid(s.gid).name} "
      new_f += "#{format('%5d', s.size.to_s)} "
      new_f += "#{s.mtime.strftime('%_m %e %H:%M')} "
      new_f += f
      files_with_info << new_f
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