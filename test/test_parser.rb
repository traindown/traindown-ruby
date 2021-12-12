require "minitest/autorun"
require "tdrb"

class ParserTest < Minitest::Test
  def test_init
    traindown = "your mom"
    parser    = TDRB::Parser.new(traindown: traindown)

    assert_equal(traindown, parser.traindown)
  end

  def test_run_basic
    traindown = <<~TD
      @ 2021-02-06
      # unit: lbs
      squat:
        500
    TD

    expected = [
      "[Date / Time] 2021-02-06",
      "[Metadata Key] unit",
      "[Metadata Value] lbs",
      "[Movement] squat",
      "[Load] 500",
    ]

    TDRB::Parser
      .new(traindown: traindown)
      .tokens.zip(expected) { |(t, e)| assert_equal(t.to_s, e) }
  end
end
