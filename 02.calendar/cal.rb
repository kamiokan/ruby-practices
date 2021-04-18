#!/usr/bin/env ruby

require 'date'
require 'optparse'
require_relative './lib/cal'

def main
  # コマンドライン引数を受け取る
  options = ARGV.getopts('m:', 'y:')
  year = options['y'].to_i
  month = options['m'].to_i

  # 入力があったかどうかチェック
  today = Date.today
  if year.zero?
    year = today.year
  end

  if month.zero?
    month = today.month
  end

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
