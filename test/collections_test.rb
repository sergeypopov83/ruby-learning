require 'minitest/autorun'
require_relative '../lib/server_helper'

class CollectionsTest < Minitest::Test

  def setup
    @servers = [
        {
            :id => 1,
            :model => 'R530',
            :cpu => [{:cores => 8, :frequency => 2.5}],
            :ram => [16, 16, 16, 16],
            :storage => [{:type => :ssd, :size => 400}, {:type => :ssd, :size => 400}, {:type => :ssd, :size => 400}, {:type => :ssd, :size => 400}]
        },
        {
            :id => 2,
            :model => 'R530',
            :cpu => [{:cores => 8, :frequency => 2.8}],
            :ram => [16, 16, 16, 16, 16, 16, 16, 16],
            :storage => [{:type => :sas, :size => 600}, {:type => :sas, :size => 600}]
        },
        {
            :id => 3,
            :model => 'R530',
            :cpu => [{:cores => 8, :frequency => 2.3}],
            :ram => [16, 16, 16, 16, 16, 16, 16, 16],
            :storage => [{:type => :sas, :size => 600}, {:type => :sas, :size => 600}, {:type => :ssd, :size => 400}, {:type => :ssd, :size => 400}]
        }
    ]
  end

  def test_ssd_only
    assert_equal [1], ServerHelper.find_ssd_only_ids(@servers)
  end

  def test_find_ids_with_ram_over_100
    assert_equal [2, 3], ServerHelper.find_ids_with_ram_over_100(@servers)
  end

  def test_find_ssd_volume_per_server
    assert_equal [{1 => 1600}, {2 => 0}, {3 => 800}], ServerHelper.find_ssd_volume_per_server(@servers)
  end

  def test_sorted_ids_by_cpu_frequency
    assert_equal [3, 1, 2], ServerHelper.sorted_ids_by_cpu_frequency(@servers)
  end
end