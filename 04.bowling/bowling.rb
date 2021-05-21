#! /usr/bin/env ruby
# frozen_string_literal: true

# フレームごとの配列に整えるパート
score = ARGV[0]
scores = score.split(',')
shots = []
scores.each do |s|
  if s == 'X' # ストライク
    shots << 10
    if shots.size < 18
      # 10フレーム目以外
      shots << 0
    end
  else
    shots << s.to_i
  end
end

frames = shots.each_slice(2).to_a

unless frames[10].nil?
  frames[9].push(frames[10]).flatten!
  frames.pop
end

# 点数計算パート
point = 0
frames.each.with_index(1) do |frame, idx|
  if idx == 10
    # 10フレーム目
    point += frame.sum
    next
  end

  # 1フレーム目から9フレーム目までの処理
  if frame[0] == 10
    # ストライクの時の計算
    next_frame = frames[idx]
    if next_frame[0] == 10 && idx != 9
      # 次のフレームもストライクで9フレーム目以外の場合
      next_next_frame = frames[idx + 1]
      point += 10 + next_frame[0] + next_next_frame[0]
    else
      point += 10 + next_frame[0] + next_frame[1]
    end
  elsif frame.sum == 10
    # スペアの時の計算
    next_frame = frames[idx]
    point += 10 + next_frame[0]
  else
    # 9本以下の場合の計算
    point += frame.sum
  end
end

puts point
