require 'minitest/autorun'

class ModuleNestingTest < Minitest::Test

  class A

    attr_accessor :log

    def initialize
      @log = []
    end

    def run
      log << 'A'
      super # will be handled via method_missing
    end

    def method_missing(name)
      @log << 'missing at A'
    end
  end

  class B < A
    def run
      log << 'B'
      super
    end

    def method_missing(name)
      @log << 'missing at B'
      super
    end
  end

  module M1
    def run
      log << 'M1'
      super
    end

    def method_missing(name)
      @log << 'missing at M1'
      super
    end
  end

  module M2
    include M1

    def run
      log << 'M2'
      super
    end

    def method_missing(name)
      @log << 'missing at M2'
      super
    end
  end

  module M3
    def run
      log << 'M3'
      super
    end

    def method_missing(name)
      @log << 'missing at M3'
      super
    end
  end

  class C < B
    include M2,M3

    def run
      log << 'C'
      super
    end

    def method_missing(name)
      @log << 'missing at C'
      super
    end
  end

  class D < B
    prepend M2
    include M3

    def run
      log << 'D'
      super
    end

    def method_missing(name)
      @log << 'missing at D'
      super
    end
  end

  class E < B
    def run
      log << 'E'
      super
    end

    def method_missing(name)
      @log << 'missing at E'
      super
    end
  end

  def test_include
    obj = C.new
    obj.run

    assert_equal ["C", "M2", "M1", "M3", "B", "A", "missing at C", "missing at M2", "missing at M1", "missing at M3", "missing at B", "missing at A"], obj.log
  end

  def test_predend
    obj = D.new
    obj.run

    assert_equal ["M2", "M1", "D", "M3", "B", "A", "missing at M2", "missing at M1", "missing at D", "missing at M3", "missing at B", "missing at A"], obj.log
  end

  def test_extend
    obj = E.new
    obj.extend(M2, M3)
    obj.run

    assert_equal ["M2", "M1", "M3", "E", "B", "A", "missing at M2", "missing at M1", "missing at M3", "missing at E", "missing at B", "missing at A"], obj.log
  end
end