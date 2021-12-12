require "json"

module TDRB
  class Result
    attr_reader :movements, :occurred_at, :performances, :source

    def initialize(
      movements: Set.new,
      occurred_at: nil,
      performances: [],
      source: ""
    )
      @movements    = movements
      @occurred_at  = occurred_at
      @performances = performances
      @source       = source
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