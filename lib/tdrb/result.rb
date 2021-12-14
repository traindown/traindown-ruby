require "json"
require "set"

module TDRB
  class Result
    attr_reader :metadata,
      :notes,
      :movements,
      :occurred_at,
      :performances,
      :source

    def initialize(
      movements: ::Set.new,
      occurred_at: nil,
      performances: [],
      source: ""
    )
      @metadata     = {}
      @movements    = movements
      @notes        = []
      @occurred_at  = occurred_at
      @performances = performances
      @source       = source
    end

    def add_performance(performance, metadata: {}, notes: [])
      raise TypeError.new("Not a performance") if !performance.is_a? Performance

      movements.add(performance.movement)

      performance.metadata = metadata
      performance.notes    = notes
      performance.sequence = performances.count

      performances << performance
    end

    def to_h
      @hash ||=
        instance_variables.each_with_object({}) do |iv, h|
          h[iv[1..].to_sym] = instance_variable_get(iv)
        end
    end

    def to_json
      @json ||= to_h.to_json
    end
  end
end