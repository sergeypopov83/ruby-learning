class Array

  # Map only elements with even indexes
  # Method accepts only blocks
  # @yield [item] Gives array element to block
  # @return [Array]
  def even_map
    self.select_even.map { |item|
      yield(item)
    }
  end

  # Reduce only elements with even indexes
  # Method accepts only blocks
  # @yield [item] Gives array element to block
  # @return [Fixnum]
  def even_reduce(acc)
    self.select_even.reduce(acc) { |result, item|
      yield(result, item)
    }
  end

  # Reduce only elements with even indexes
  # Method accepts lambdas and Procs
  # @param [lambda]
  # @return [Fixnum]
  def even_reduce_arg(acc, func)
    self.select_even.reduce(acc) { |result, item|
      func.call(result, item)
    }
  end

  # Map elements
  # Method accepts only blocks
  # @yield [prev, current, nexts] Gives current and sibling elements to block
  # @return [Fixnum]
  def map_with_siblings
    self.map.with_index { |_, index|
      yield(
        index > 0 ? self.at(index - 1) : nil,
          self[index],
          index < self.count() - 1 ? self[index + 1] : nil
      )
    }
  end

  protected

  def select_even
    self.select.each_with_index { |_, index| index.even? }
  end
end

