#!/usr/bin/env ruby

require 'date'
require 'paint'

# カレンダー日付を表示する
def print_days(first_day, last_day, today)
  (first_day..last_day).each do |day|
    output_day = day.strftime('%e')

    # 今日だったら反転して表示する
    if day == today
      print "#{Paint[output_day, :black, :green]} "
    else
      print "#{output_day} "
    end

    # 土曜日だったら改行する
    if day.saturday?
      puts ''
    end
  end
end

# カレンダー日付の1日の前のスペースを表示する
def print_space(first_day)
  (3 * first_day.wday).times do
    print ' '
  end
end
