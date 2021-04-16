#!/usr/bin/env ruby

require 'date'
require 'paint'

# 曜日を取得する
def get_week_day(date_object)
  date_object.strftime('%a')
end

# 土曜日かどうかチェックする
def is_saturday(day_object)
  if get_week_day(day_object) == 'Sat'
    true
  else
    false
  end
end

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
    if is_saturday(day)
      puts ''
    end
  end
end

# カレンダー日付の1日の前のスペースを表示する
def print_space(first_day)
  space = count_space(first_day)
  space.times do
    print ' '
  end
end

# 1日（初日）の曜日によって、出力前にスペースを出力する
def count_space(first_day)
  space_hash = { Sun: 0, Mon: 3, Tue: 6, Wed: 9, Thu: 12, Fri: 15, Sat: 18 }
  space_hash[:"#{first_day.strftime('%a')}"]
end
