module Enumerable
  def my_each
    return to_enum(:my_each) unless block_given?

    (0...length).each do |index|
      yield self[index]
    end
    self
  end

  def my_each_with_index
    return to_enum(:my_each_with_index) unless block_given?

    (0...length).each do |index|
      yield(self[index], index)
    end
    self
  end

  def my_select
    return to_enum(:my_select) unless block_given?

    result = []
    my_each do |e|
      output << e if yield e
    end
    result
  end

  def my_all?
    return to_enum(:my_all?) unless block_given?

    result = false
    my_each do |e|
      result = true if yield e
    end
    result
  end

  def my_any?
    return to_enum(:my_any?) unless block_given?

    result = false
    my_each do |e|
      result = true if yield e
    end
    result
  end

  def my_none?
    return to_enum(:my_none?) unless block_given?

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

  def my_map
    return to_enum(:my_map) unless block_given?

    array = []
    my_each do |e|
      array << yield(e)
    end
    array
  end

  def my_inject(acc = nil)
    return to_enum(:my_inject) unless block_given?

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

arr = [1, 2, 3, 4, 5]
puts arr.my_inject
