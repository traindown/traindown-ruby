require "minitest/autorun"
require "tdrb"

class ResultTest < Minitest::Test
  def test_to_json
    movements    = ["your mom"]
    occurred_at  = Time.now
    performances = [TDRB::Performance.new(movement: "squat", load: 500)]
    source       = "your mom"

    expected = {
      metadata: {},
      movements: movements,
      notes: [],
      occurred_at: occurred_at,
      performances: performances.map(&:to_h),
      source: source
    }
    result =
      TDRB::Result
        .new(**expected.reject { |k, _| [:metadata, :notes].include?(k) })

    assert_equal(result.to_json, expected.to_json)
  end
end
