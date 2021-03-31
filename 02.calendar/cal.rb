require 'date'

def main

end

def test
  first_day = get_first_day(2021, 3)
  last_day = get_last_day(2021, 3)
  p first_day
  p last_day
  p get_today
  d = get_first_day(2021, 3)
  p get_week_day(d)

  not_saturday = Date.new(2021, 3, 1)
  saturday = Date.new(2021, 3, 6)
  p is_saturday(not_saturday)
  p is_saturday(saturday)

  sunday = Date.new(2021, 3, 7)
  p count_space(sunday)
  p count_space(saturday)

  print_month_and_year(2021, 3)
  print_week_day
  print_space(first_day)
  print_days(first_day, last_day)
  puts ""
end

# y年m月の最初の日を求める
def get_first_day(year, month)
  Date.new(year, month, 1)
end

# y年m月の最後の日を求める
def get_last_day(year, month)
  Date.new(year, month, -1)
end

# 今日の日付を求める
def get_today
  Date.today
end

# 曜日を取得する
def get_week_day(date_object)
  date_object.strftime('%a')
end

# 月と年を表示する
def print_month_and_year(year, month)
  puts "      #{month}月 #{year}"
end

# 曜日の行を表示する
def print_week_day
  puts "日 月 火 水 木 金 土"
end

# カレンダー日付を表示する
def print_days(first_day, last_day)
  (first_day..last_day).each do |day|
    print day.strftime('%e') + " "
    if is_saturday(day)
      puts ""
    end
  end
end

# カレンダー日付の1日の前のスペースを表示する
def print_space(first_day)
  space = count_space(first_day)
  space.times do
    print " "
  end
end

# 1日（初日）の曜日によって、出力前にスペースを出力する
def count_space(first_day)
  space_hash = {Sun: 0, Mon: 3, Tue: 5, Wed: 7, Thu: 9, Fri: 11, Sat: 13}
  space_hash[:"#{first_day.strftime('%a')}"]
end

# 土曜日かどうかチェックする
def is_saturday(day_object)
  if get_week_day(day_object) == "Sat"
    true
  else
    false
  end
end

test
# main
