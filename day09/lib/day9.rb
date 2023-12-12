# frozen_string_literal: true
require_relative "day9/version"

class Pattern
  def initialize(ints)
    @ints = ints
    if ints.length == 1
      @sub_pattern = nil
    else
      new_ints = ints.each_cons(2).map { |a, b| b - a }
      @sub_pattern = Pattern.new new_ints
    end
  end
  def next
    if @sub_pattern == nil
      0
    else
      @sub_pattern&.next + @ints.last
    end
  end
  def previous
    if @sub_pattern == nil
      0
    else
      @ints.first - @sub_pattern&.previous
    end
  end
end

patterns = []
File.readlines('input.txt', chomp: true).each do |line|
  patterns.push(
    Pattern.new line.split(" ").map(&:to_i)
  )
end

puts patterns.map(&:next).sum
puts patterns.map(&:previous).sum
