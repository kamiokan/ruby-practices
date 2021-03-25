#!/usr/bin/env ruby
# frozen_string_literal: true

i = 1
20.times do
  if (i % 3).zero? && (i % 5).zero?
    puts 'FizzBuzz'
  elsif (i % 3).zero?
    puts 'Fizz'
  elsif (i % 5).zero?
    puts 'Buzz'
  else
    puts i
  end

  i += 1
end
