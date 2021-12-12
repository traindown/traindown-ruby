require "minitest/autorun"
require "tdrb"

class ResultTest < Minitest::Test
  def test_to_json
    movements    = ["your mom"]
    occurred_at  = Time.now
    performances = ["your mom"]
    source       = "your mom"

    expected = {
      movements: movements,
      occurred_at: occurred_at,
      performances: performances,
      source: source
    }
    result = TDRB::Result.new(**expected)

    assert_equal(result.to_json, expected.to_json)

  end
end
