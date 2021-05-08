#! /usr/bin/env ruby

# フレームごとの配列に整えるパート
score = ARGV[0]
scores = score.split(',')
shots = []
scores.each do |s|
  if s == 'X' # ストライク
    if shots.size >= 18
      # 10フレーム目
      shots << 10
    else
      shots << 10
      shots << 0
    end
  else
    shots << s.to_i
  end
end

frames = []
shots.each_slice(2) do |s|
  frames << s
end

unless frames[10].nil?
  frames[9].push(frames[10]).flatten!
  frames.delete_at(10)
end

#　点数計算パート
point = 0
frame_number = 1
frames.each do |frame|
  if frame_number == 10
    # 10ゲーム目
    point += frame.sum
  else
    if frame[0] == 10
      # ストライクの時の計算
      next_frame = frames[frame_number]
      if next_frame[0] == 10 && frame_number != 9
        # 次のフレームもストライクで9フレーム目以外の場合
        next_next_frame = frames[frame_number + 1]
        point += 10 + next_frame[0] + next_next_frame[0]
      else
        point += 10 + next_frame[0] + next_frame[1]
      end
    elsif frame.sum == 10
      # スペアの時の計算
      next_frame = frames[frame_number]
      point += 10 + next_frame[0]
    else
      # 9本以下の場合の計算
      point += frame.sum
    end
  end
  frame_number += 1
end

puts point

# next_frame = frames[frame_number] の frame_number が気持ち悪い
