require 'minitest/autorun'

#global scope
def double_a
  @a * 2
end

def init_b
  @b = 15
end

class ScopeTest < Minitest::Test

  def test_global_function
    @a = 2
    assert_equal 4, double_a
  end

  def test_global_variable
    init_b
    assert_equal 15, @b
  end
end