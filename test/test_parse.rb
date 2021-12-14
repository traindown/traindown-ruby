require "time"
require "minitest/autorun"
require "tdrb"

class ParseTest < Minitest::Test
  def test_run_basic
    traindown = <<~TD
      @ 2021-02-07
      # session meta: true
      * session note
      squat:
        # squat meta: true
        * squat note
        500
          # 500 meta: true
          * 500 note
    TD

    results = TDRB.parse(traindown: traindown)
    assert_equal(results.count, 1)

    session = results.first
    assert_equal(session.occurred_at, Time.parse("2021-02-07"))
    assert_equal(session.metadata, { "session meta" => "true"})
    assert_equal(session.movements, Set.new(["squat"]))
    assert_equal(session.notes, ["session note"])
    assert_equal(
      session.performances.first,
      TDRB::Performance.new(
        fails: 0,
        load: 500.0,
        metadata: {
          "squat meta" => "true",
          "500 meta" => "true",
        },
        movement: "squat",
        notes: ["squat note", "500 note"],
        reps: 1,
        sequence: 0,
        sets: 1,
      )
    )
  end
end
