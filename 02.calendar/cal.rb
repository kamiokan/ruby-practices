#!/usr/bin/env ruby

require 'date'
require 'optparse'
require 'paint'
require_relative './lib/cal'

def main
  # コマンドライン引数を受け取る
  options = ARGV.getopts('m:', 'y:')
  year = options['y'].to_i
  month = options['m'].to_i

  # 入力があったかどうかチェック
  today = get_today
  if year.zero? && month.zero?
    year = today.year
    month = today.month
  elsif year.zero?
    year = today.year
  elsif month.zero?
    month = today.month
  end

  first_day = get_first_day(year, month)
  last_day = get_last_day(year, month)

  # 出力処理
  print_month_and_year(year, month)
  print_week_day
  print_space(first_day)
  print_days(first_day, last_day)
  puts ''

  puts Paint['hoge', :black, :green]
end

main
