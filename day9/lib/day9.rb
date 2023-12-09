# frozen_string_literal: true

require_relative "day9/version"

class Pattern
  attr_accessor :ints, :sub_pattern

  def initialize(ints)
    @ints = ints
    @sub_pattern = derive
  end

  def derive
    if ints.length == 1
      nil
    else
      new_ints = ints.each_cons(2).map { |a, b| b - a }
      Pattern.new new_ints
    end
  end

  def is_done
    ints.all? { |i| i == 0 }
  end

  def to_s
    ints.join(",")
  end

  def next
    if sub_pattern == nil
      0
    else
      sub_pattern.next + ints.last
    end
  end

  def before
    if sub_pattern == nil
      0
    else
      ints.first - sub_pattern.before
    end
  end
end

patterns = []

File.readlines('input.txt', chomp: true).each do |line|
  patterns.push(Pattern.new line.split(" ").map { |it| Integer(it) })
end

puts patterns.map { |p| p.next}.sum
puts patterns.map { |p| p.before}.sum
