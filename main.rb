# rubocop: disable Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity

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
    elsif !param.nil? && param.instance_of?(Regexp)
      to_a.my_each { |item| return true if param.match(item) }
    else
      to_a.my_each { |item| return true if item == param }
    end
    false
  end

  def my_none?(res = nil)
    block_given? ? !my_any?(&Proc.new) : !my_any?(res)
  end

  def my_count(par = nil)
    count = 0
    if block_given?
      to_a.my_each { |i| count += 1 if yield(i) }
    elsif !block_given? && par.nil?
      count = to_a.length
    else
      count = to_a.my_select { |i| i == par }.length
    end
    count
  end

  def my_map(pro = nil)
    return to_enum(:my_map) unless block_given?

    array = []
    if pro.nil?
      to_a.my_each { |i| array << yield(i) }
    else
      to_a.my_each { |i| array << pro.call(i) }
    end
    array
  end

  def my_inject(ini = nil, sym = nil)
    if (!ini.nil? && sym.nil?) && (ini.is_a?(Symbol) || ini.is_a?(String))
      sym = ini
      ini = nil
    end
    if !block_given? && !sym.nil?
      to_a.my_each { |i| ini = ini.nil? ? i : ini.send(sym, i) }
    else
      to_a.my_each { |i| ini = ini.nil? ? i : yield(ini, i) }
    end
    ini
  end
end

# rubocop: enable Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity

array = [6, 19, 19, 25, 7, 30, 20, 27, 22, 19, 18, 29, 12, 31, 2, 12, 0, 32, 1, 20]
# block = proc { |num| num < (0 + 9) / 2 }
rang = Range.new(5, 50)
# false_block = proc { |num| num > 9 }
# true_block = proc { |num| num <= 9 }
numbers = [1, 2i, 3.14]
words = %w[programmer computer house car]
true_any_array = [nil, false, true, []]
false_any_array = [nil, false, nil, false]
true_array = [1, true, 'hi', []]
false_array = [1, false, 'hi', []]

def multiply_els(array)
  array.my_inject(1, '*')
end

puts '#my_each test'
array.my_each { |num| puts num }
words.my_each { |word| puts word }

puts '#my_each_index test'
array.each_with_index { |guess, index| puts "Guess ##{index} is #{guess}" }

puts '#my_select test'
puts(array.select { |val| val == 1 })

puts '#my_all? test'
puts(true_array.my_all?)
puts(false_array.my_all?)
puts numbers.my_all?(Numeric)

puts '#my_any? test'
puts(true_any_array.my_any?)
puts(false_any_array.my_any?)

puts '#my_map test'
puts(array.my_map { |n| n * 2 })
puts(rang.my_map { |n| n * 2 })
