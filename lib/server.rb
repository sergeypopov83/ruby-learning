class Server

  def initialize
    @memory_list = []
    @cpu_list = []
  end

  def memory_size
    @memory_list.reduce(0) { |sum, item|
      sum + item.size
    }
  end

  def add_cpu(cpu)
    if cpu.generation != 3
      raise 'Unsupported CPU generation'
    elsif @cpu_list.count >= 2
      raise 'Too much CPUs'
    elsif @cpu_list.count > 0 && @cpu_list[0] != cpu
      raise 'Different CPUs'
    end
    @cpu_list.push(cpu)
  end

  def add_memory(memory)
    if memory.type != :ddr4
      raise 'Unsupported memory type'
    elsif @memory_list.count >= 16
      raise 'Too much memory modules'
    end
    @memory_list.push(memory)
  end

  def bootable?
    @memory_list.count > 0 && @cpu_list.count > 0
  end
end

class CPU

  attr_reader :generation, :cores, :id, :frequency

  def initialize(id, frequency, cores, generation)
    @id = id
    @frequency = frequency
    @cores = cores
    @generation = generation
  end

  def ==(other)
    @frequency == other.frequency && @cores == other.cores && @generation == other.generation
  end
end

class Memory

  attr_reader :type, :size

  def initialize(type, size)
    @type = type
    @size = size
  end

  def ==(other)
    @type == other.type && @size == other.size
  end
end