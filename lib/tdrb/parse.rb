require "time"

module TDRB
  ## Returns Array<Result> to allow for multisession documents.
  def self.parse(traindown:)
    metakey_buf    = nil
    movement_meta  = {}
    movement_notes = []
    result         = nil
    performance    = nil

    Parser
      .new(traindown: traindown)
      .tokens
      .each_with_object([]) do |token, arr|
        case token.type
        when Token::DATETIME
          arr << result if !result.nil?

          occurred_at = safe_time(token.literal)
          result      = Result.new(occurred_at: occurred_at)
        when Token::FAIL
          fails = safe_float(token.literal)

          (performance || Performance.new).fails = fails
        when Token::LOAD
          if performance.nil? || performance.load
            result.add_performance(performance) if performance&.load

            performance =
              Performance.new(
                movement: performance&.movement,
                load: safe_float(token.literal),
              )
          else
            performance.load = safe_float(token.literal)
          end
        when Token::METAKEY
          metakey_buf = token.literal
          target = performance.nil? ? result.metadata : movement_meta
          target[metakey_buf] = ""
        when Token::METAVALUE
          target = performance.nil? ? result.metadata : movement_meta
          target[metakey_buf] = token.literal
          metakey_buf = nil
        when Token::MOVEMENT
          if !performance.nil?
            result
              .add_performance(
                performance,
                metadata: movement_metadata,
                notes: movement_notes,
              )
          end

          performance = Performance.new(movement: token.literal)
        when Token::NOTE
          target = performance.nil? ? result.notes : movement_notes
          target << token.literal
        when Token::REP
          reps = safe_float(token.literal)

          (performance || Performance.new).reps = reps
        when Token::SET
          sets = safe_float(token.literal)

          (performance || Performance.new).sets = sets
        when Token::SUPERSET
        end
      end.tap do |results|
        return results if result.nil?

        result.add_performance(performance) if !performance.nil?
        results << result
      end
  end

  def self.safe_float(maybe_float_str)
    Float(maybe_float_str)
  rescue
    0.0
  end

  def self.safe_time(maybe_time_str)
    Time.parse(maybe_time_str)
  rescue
    Time.now
  end
end
