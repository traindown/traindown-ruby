module TDRB
  class Performance
    attr_accessor :fails,
      :load,
      :metadata,
      :movement,
      :notes,
      :sequence,
      :sets,
      :reps

    def initialize(
      fails: 0,
      load: nil,
      movement: "Unidentified Movement",
      metadata: {},
      notes: [],
      reps: 1,
      sequence: 0,
      sets: 1
    )
      @fails    = 0
      @load     = load
      @movement = movement
      @metadata = metadata
      @notes    = notes
      @reps     = 1
      @sequence = 0
      @sets     = 1
    end

    def ==(p)
      raise TypeError.new("Not a Performance") if !p.is_a? Performance

      p.movement == movement &&
        p.reps == reps &&
        p.sets == sets &&
        p.fails == fails &&
        p.load == load
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

    def volume
      (load || 0.0) * sets * (reps - fails)
    end
  end
end
