require 'minitest/autorun'
require_relative '../lib/cal'

class CalTest < Minitest::Test
  def test_get_week_day
    the_day = Date.new(2021, 4, 1)
    assert_equal get_week_day(the_day), 'Thu'
  end

  def test_is_saturday
    not_saturday = Date.new(2021, 3, 1)
    assert_equal is_saturday(not_saturday), false

    saturday = Date.new(2021, 3, 6)
    assert_equal is_saturday(saturday), true
  end
end
