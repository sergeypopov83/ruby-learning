# expected server array structure
#
# {
#   :id => 1,
#   :model => 'R530',
#   :cpu => [{:cores => 8, :frequency => 2.5}],
#   :ram => [16, 16, 16, 16],
#   :storage => [{:type => :ssd, :size => 400}]
# }
class ServerHelper

  # @param servers Array
  # @return server ids
  def self.find_ssd_only_ids(servers)
    servers.select { |server|
      storage_types = server[:storage].map{|storage| storage[:type]}.uniq
      storage_types == [:ssd]
    }.map {|server| server[:id]}
  end

  # @param servers Array
  # @return server ids
  def self.find_ids_with_ram_over_100(servers)
    servers.select { |server|
      server[:ram].reduce(:+) > 100
    }.map{ |item|
      item[:id]
    }
  end

  # @param servers Array
  # @return Array [{server_id => total_ssd_volume}]
  def self.find_ssd_volume_per_server(servers)
    servers.map { |server|
      ssd_storage = server[:storage].reduce(0) { |acc, item|
        item[:type] == :ssd ? acc += item[:size] : acc
      }
      {server[:id] => ssd_storage}
    }
  end

  # @param servers Array
  # @return Array server ids ordered by incresing of frequency
  def self.sorted_ids_by_cpu_frequency(servers)
    servers.map{ |server|
      total_frequency = server[:cpu].reduce(0) { |acc, cpu| acc + cpu[:cores] * cpu[:frequency]}
      {:id => server[:id], :total_frequency => total_frequency}
    }.sort{ |a, b|
      a[:total_frequency] <=> b[:total_frequency]
    }.map{ |item|
      item[:id]
    }
  end


end