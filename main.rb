# rubocop: disable Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity
module Enumerable
  def my_each
    (0...length).each do |index|
      yield self[index]
    end
    self
  end

  def my_each_with_index
    (0...length).each do |index|
      yield(self[index], index)
    end
    self
  end

  def my_select
    result = []
    my_each do |e|
      output << e if yield e
    end
    result
  end

  def my_all?
    result = false
    my_each do |e|
      result = true if yield e
    end
    result
  end

  def my_any
    result = false
    my_each do |e|
      result = true if yield e
    end
    result
  end

  def my_none
    result = true
    my_each do |e|
      result = false if yield e
    end
    result
  end

  def my_count
    return length unless block_given?

    count = 0
    my_each do |e|
      count += 1 if yield e
    end
    count
  end

  def my_inject(acc = nil)
    if acc.nil?
      acc = self[0]
      index = 1
    else
      index = 0
    end

    (index...length).each do |i|
      acc = yield(acc, self[i])
    end
    acc
  end
end

x_array = [2, 3, 4, 5, 6]

def multiply_els(arr)
  arr.my_inject { |acc, value| acc * value }
end

multiply_els(x_array)

x_array.my_each do |e|
  puts e * 2
end
