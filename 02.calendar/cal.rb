#!/usr/bin/env ruby

require 'date'
require 'optparse'
require_relative './lib/cal'

def main
  today = Date.today

  # コマンドライン引数を受け取る
  options = ARGV.getopts('m:', 'y:')
  year = (options['y'] || today.year).to_i
  month = (options['m'] || today.month).to_i

  first_day = Date.new(year, month, 1)
  last_day = Date.new(year, month, -1)

  # 出力処理
  puts "      #{month}月 #{year}"
  puts '日 月 火 水 木 金 土'
  print_space(first_day)
  print_days(first_day, last_day, today)
  puts ''
end

main
