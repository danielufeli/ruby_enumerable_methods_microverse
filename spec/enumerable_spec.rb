require_relative '../main'

array = [6, 19, 25, 7, 30, 20, 27]
rang = Range.new(5, 10)
hash = { '1' => 1, '2' => 2 }
numbers = [1, 2, 3.14, 5]
num = [1, 2, 4, 5]
words = %w[programmer computer house car]
true_any_array = [nil, false, true, []]
false_any_array = [nil, false, nil, false]
true_array = [1, true, 'hi', []]
false_array = [1, false, 'hi', []]

describe Enumerable do
  describe '#my_each' do
    it 'should print the elements in the array' do
      expect { array.my_each { |x| puts x } }.to output("6\n19\n25\n7\n30\n20\n27\n").to_stdout
    end

    it 'should print the elements in the range' do
      expect do
        rang.my_each do |x|
          puts x
        end
      end.to output("5\n6\n7\n8\n9\n10\n").to_stdout
    end

    it 'should return enumerator' do
      expect(rang.my_each).to be_an_instance_of Enumerator
    end

    it 'should print elements of a hash' do
      expect { hash.my_each { |x| print x } }.to output('["1", 1]["2", 2]').to_stdout
    end

    it 'should print the elements in the array of strings' do
      expect do
        words.my_each do |x|
          puts x
        end
      end.to output("programmer\ncomputer\nhouse\ncar\n").to_stdout
    end
  end
  describe '#my_each_with_index' do
    it 'should print the elements in the array with their indexes' do
      expect do
        array.my_each_with_index { |guess, index| puts "Guess ##{index} is #{guess}" }
      end.to output(
        "Guess #0 is 6\nGuess #1 is 19\nGuess #2 is 25\nGuess #3 is 7\nGuess #4 is 30\nGuess #5 is 20\nGuess #6 is 27\n"
      ).to_stdout
    end

    it 'should print the elements in the range with their indexes' do
      expect do
        rang.my_each_with_index do |x, index|
          puts "#{x} #{index}"
        end
      end.to output("5 0\n6 1\n7 2\n8 3\n9 4\n10 5\n").to_stdout
    end

    it 'should return enumerator' do
      expect(rang.my_each_with_index).to be_an_instance_of Enumerator
    end

    it 'should print keys, values and indexes of elements in hash' do
      expect do
        hash.my_each_with_index do |(key, value), index|
          puts "#{key} > #{value} > #{index}"
        end
      end.to output("1 > 1 > 0\n2 > 2 > 1\n").to_stdout
    end

    it 'should print the elements in the array of strings with their indexes' do
      expect do
        words.my_each_with_index do |x, index|
          puts "#{x} #{index}"
        end
      end.to output("programmer 0\ncomputer 1\nhouse 2\ncar 3\n").to_stdout
    end
  end
  describe '#my_select' do
    it 'should return enumerator' do
      expect(rang.my_select).to be_an_instance_of Enumerator
    end

    it 'should return array containing the numbers smaller than 4' do
      expect(numbers.my_select { |x| x < 4 }).to eql([1, 2, 3.14])
    end

    it 'should return the even numbers in the given range' do
      expect(rang.my_select(&:even?)).to eql([6, 8, 10])
    end

    it 'should return an array containing the strings that are less than 6' do
      expect(words.my_select { |x| x.size < 6 }).to eql(%w[house car])
    end
  end

  describe '#my_all' do
    it 'should return true' do
      expect(true_array.my_all?).to eql(true)
    end

    it 'should return false' do
      expect(false_array.my_all?).to eql(false)
    end

    it 'should return true when the length of all the words in the array is greater than 2' do
      expect(words.my_all? { |word| word.length > 2 }).to eql(true)
    end

    it 'should return true if all of the element in array are Numeric' do
      expect(numbers.my_all?(Numeric)).to eql(true)
    end
  end
  describe '#my_any' do
    it 'should return true' do
      expect(true_any_array.my_any?).to eql(true)
    end

    it 'should return false' do
      expect(false_any_array.my_any?).to eql(false)
    end

    it 'should return true when at least length of one  words in the array is greater than 2' do
      expect(words.my_any? { |word| word.length > 2 }).to eql(true)
    end

    it 'should return true if there is a floating number' do
      expect(numbers.my_any?(Float)).to eql(true)
    end
  end
  describe '#my_none' do
    it 'should return true if none of the elements in the array has length greater than 29' do
      expect(words.my_none? { |word| word.length >= 29 }).to eql(true)
    end

    it 'should return false if there is false element in the array' do
      expect(false_array.my_none?).to eql(false)
    end

    it 'should return true if the array is empty' do
      expect([].my_none?).to eql(true)
    end

    it 'should return false if there is at least one element in the array that is equal to 5' do
      expect(numbers.my_none?(5)).to eql(false)
    end
  end
  describe '#my_count' do
    it 'should count the number of elements in the array' do
      expect(array.my_count).to eql(7)
    end

    it 'should count the number of elements in the range' do
      expect(rang.my_count).to eql(6)
    end

    it 'should count the number of even elements in the array which is 2' do
      expect(num.my_count(&:even?)).to eql(2)
    end

    it 'should count the number of words' do
      expect(words.my_count).to eql(4)
    end
  end
  describe '#my_map' do
    it 'should mutiply all elements by 2 in the given array' do
      expect(array.my_map { |n| n * 2 }).to eql([12, 38, 50, 14, 60, 40, 54])
    end

    it 'should return the instance of the Enumerator' do
      expect(rang.my_map).to be_an_instance_of Enumerator
    end

    it 'should mutiply all elements by 2 in the given range' do
      expect(rang.my_map { |n| n * 2 }).to eql([10, 12, 14, 16, 18, 20])
    end

    it 'should add 2 to all elements' do
      expect(num.my_map { |n| n + 2 }).to eql([3, 4, 6, 7])
    end
  end
  describe '#my_inject' do
    it 'should sum all the numbers in the given range' do
      expect(rang.my_inject { |sum, n| sum + n }).to eql 45
    end

    it 'should return the multiplication of the element in the array' do
      expect(numbers.my_inject { |mul, n| mul * n }).to eql 31.400000000000002
    end

    it 'should raise error when neither block nor argument are given' do
      expect { num.my_inject }.to raise_error(LocalJumpError)
    end
  end
  describe '#multiply_els' do
    it 'Test multiply_els method' do
      expect($stdout).to receive(:puts).with(323_190_000)
      puts multiply_els(array)
    end
  end
end
