module Enumerable
  def my_each
    return to_enum(:my_each) unless block_given?

    i = 0
    while i < to_a.length
      yield to_a[i]
      i += 1
    end
    self
  end  
  def my_each_with_index
    return to_enum(:my_each_with_index) unless block_given?
    
    i = 0
    while i < to_a.length
      yield(to_a[i], i)
      i += 1
    end
    self
  end
  def my_select
    return to_enum(:my_select) unless block_given?

    new_array = []
    to_a.my_each { |value| new_array << value if yield value }
    new_array
  end
  def my_all?(param = nil)
    if !block_given? && !param
      to_a.my_each { |val| return false unless val }
    elsif param.is_a?(Class)
      to_a.my_each { |val| return false unless val.is_a?(param) }
    elsif param.is_a?(Regexp)
      to_a.my_each { |val| return false unless param.match(val) }
    elsif param
      to_a.my_each { |val| return false unless val == param }
    else
      to_a.my_each { |val| return false unless yield(val) }
    end
    true
  end

 def my_any?(param = nil)
    if block_given?
      to_a.my_each { |item| return true if yield(item) }
      return false
    elsif param.nil?
      to_a.my_each { |item| return true if item }
    elsif !param.nil? && (param.is_a? Class)
      to_a.my_each { |item| return true if [item.class, item.class.superclass].include?(param) }
    elsif !param.nil? && param.class == Regexp
      to_a.my_each { |item| return true if param.match(item) }
    else
      to_a.my_each { |item| return true if item == param }
    end
    false
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
