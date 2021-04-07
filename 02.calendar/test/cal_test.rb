require 'minitest/autorun'
require_relative '../lib/cal'

class CalTest < Minitest::Test
  def test_get_first_day
    first_day = get_first_day(2021, 4)
    assert_equal first_day.strftime('%d'), '01'
  end

  def test_get_last_day
    last_day = get_last_day(2021, 4)
    assert_equal last_day.strftime('%d'), '30'
  end

  def test_get_week_day
    the_day = get_first_day(2021, 4)
    assert_equal get_week_day(the_day), 'Thu'
  end

  def test_is_saturday
    not_saturday = Date.new(2021, 3, 1)
    assert_equal is_saturday(not_saturday), false

    saturday = Date.new(2021, 3, 6)
    assert_equal is_saturday(saturday), true
  end
end
