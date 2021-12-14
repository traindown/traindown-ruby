require "minitest/autorun"
require "tdrb"

class PerformanceTest < Minitest::Test
  def test_default_init
    assert_equal(
      TDRB::Performance.new,
      TDRB::Performance.new(
        fails: 0,
        load: nil,
        movement: "Unidentified Movement",
        metadata: {},
        notes: [],
        reps: 1,
        sequence: 0,
        sets: 1,
      )
    )
  end

  def test_volume
    performance = TDRB::Performance.new
    assert_equal(performance.volume, 0.0)

    performance.load = 100
    assert_equal(performance.volume, 100.0)

    performance.reps = 10
    assert_equal(performance.volume, 1_000.0)

    performance.sets = 10
    assert_equal(performance.volume, 10_000.0)

    performance.sets = 1
    performance.fails = 9
    assert_equal(performance.volume, 100.0)
  end
end
