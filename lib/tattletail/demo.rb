require 'tattletail'

module Tattletail
  class Fib
    def no_args
      5
    end
    tattle_on :no_args

    def fib x
      return 1 if x <= 2
      fib(x - 1) + fib(x - 2)
    end
    tattle_on_instance_method :fib

    def self.fib x
      return 1 if x <= 2
      fib(x - 1) + fib(x - 2)
    end
    tattle_on :fib

    def self.find x
      return 1 if x <= 2
      find(x - 1) + find(x - 2)
    end
    tattle_on_class_method :find

    def find x
      x * 2
    end
    tell_on_instance_method :find

    def fib_block &blk
      fib yield
    end
    tell_on :fib_block

    def fib_raise n
      raise 'This method always raises a generic exception'
    end
    tell_on :fib_raise

    def fib_missing n
      foo n
    end
    tell_on :fib_missing

    def raise_test
      5.times do |n|
        if n % 2 == 0
          fib n
        else
          begin
            if n % 4 == 1
              fib_raise n
            else
              fib_missing n
            end
          rescue Exception => e
            e
          end
          n
        end
      end
    end
    tell_on :raise_test
  end

  module Merge
    extend Tattletail

    def self.sample_array
      [3,7,5,1,2,9,8,0,2,3,5,2,4,1,6,7,8,4,6,2,1]
    end

    def self.mergesort(list = sample_array)
      return list if list.size <= 1
      mid = list.size / 2
      left  = list[0, mid]
      right = list[mid, list.size]
      merge(mergesort(left), mergesort(right))
    end
    tattle_on :mergesort

    def self.merge(left, right)
      sorted = []
      until left.empty? or right.empty?
        if left.first <= right.first
          sorted << left.shift
        else
          sorted << right.shift
        end
      end
      sorted.concat(left).concat(right)
    end
    tattle_on :merge
  end
end
