class Server

  attr_reader :cpu, :memory

  def initialize
    @memory = MemorySlots.new(memory_slots_quantity, memory_slots_type)
    @cpu = CpuSockets.new(cpu_sockets_quantity, cpu_sockets_type)
  end

  def self.memory_slots(quantity, type)
    define_method(:memory_slots_quantity) do
      quantity
    end
    define_method(:memory_slots_type) do
      type
    end
  end

  def self.cpu_sockets(quantity, type)
    define_method(:cpu_sockets_quantity) do
      quantity
    end

    define_method(:cpu_sockets_type) do
      type
    end
  end

  def memory_size
    @memory.memory_size
  end

  def bootable?
    @memory.bootable? && @cpu.bootable?
  end

end

class MemorySlots
  def initialize(qty, type)
    @qty = qty
    @type = type
    @slots = []
  end

  def << (memory)
    if memory.type != @type
      raise InvalidConfiguration.new('Unsupported memory type')
    elsif @slots.count() >= @qty
      raise InvalidConfiguration.new('No more memory slots left')
    else
      @slots << memory
    end
  end

  def memory_size
    @slots.map{|s| s.size}.reduce(:+)
  end

  def bootable?
    @slots.count > 0
  end

end

class CpuSockets
  def initialize(qty, type)
    @qty = qty
    @type = type
    @sockets = []
  end

  def << (cpu)
    if cpu.generation != @type
      raise InvalidConfiguration.new('Unsupported CPU type')
    elsif @sockets.count() >= @qty
      raise InvalidConfiguration.new('No more sockets left')
    elsif @sockets.count() > 0 && @sockets[0] != cpu
      raise InvalidConfiguration.new('All CPUs should by identical')
    else
      @sockets << cpu
    end
  end

  def bootable?
    @sockets.count > 0
  end
end


class CPU

  attr_reader :generation, :cores, :frequency

  def initialize(frequency, cores, generation)
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

class InvalidConfiguration < RuntimeError

end
