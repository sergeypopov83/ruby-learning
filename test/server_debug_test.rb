require 'minitest/autorun'
require_relative '../lib/container'
require_relative '../lib/debug'

class ServerDebugTest < Minitest::Test

  class R730 < Server
    memory_slots 32, :ddr4
    cpu_sockets 2, :haswell
  end

  class DDR4_16 < Memory
    def initialize
      super :ddr4, 16
    end

    def to_s
      'memory %s %sGB' % [type, size]
    end
  end

  class E5_4650 < CPU
    def initialize
      super 2100, 12, :haswell
    end

    def to_s
      'cpu %s %scores %sGHz' % [type, cores, frequency]
    end
  end

  def test_include_debug_module
    server = R730.new
    server.extend Debug

    server.enable_debug
    server.memory << DDR4_16.new
    server.cpu << E5_4650.new
    server.memory << DDR4_16.new
    server.disable_debug
    server.memory << DDR4_16.new # should not be logged
    server.cpu << E5_4650.new # should not be logged

    assert_equal 48, server.memory_size
    assert_equal 2, server.cpu.size
    assert_equal ['added memory ddr4 16GB', 'added cpu haswell 12cores 2100GHz', 'added memory ddr4 16GB'], server.debug_log
  end
end