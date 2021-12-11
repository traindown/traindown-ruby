module TDRB
  class Token
    attr_reader :literal, :type

    DATETIME  = "Date / Time".freeze
    FAIL      = "Fails".freeze
    LOAD      = "Load".freeze
    METAKEY   = "Metadata Key".freeze
    METAVALUE = "Metadata Value".freeze
    MOVEMENT  = "Movement".freeze
    NOTE      = "Note".freeze
    REP       = "Reps".freeze
    SET       = "Sets".freeze
    SUPERSET  = "Superset Movement".freeze

    TOKEN_SYMBOLS = %i[
      datetime fail load metakey metavalue movement note rep set superset
    ]

    ALLOWED_TYPES = TOKEN_SYMBOLS.map { |ts| const_get(ts.upcase) }.freeze

    EOF = "\x00".freeze

    class << self
      TOKEN_SYMBOLS.each do |method|
        define_method(method) do |literal|
          new(literal: literal, type: const_get(method.upcase))
        end
      end
    end

    def initialize(literal:, type:)
      raise TokenTypeError if !ALLOWED_TYPES.include?(type)

      @literal = literal
      @type    = type
    end

    def ==(t)
      raise TokenArgumentError.new("Invalid comparison") if !t.is_a? Token

      literal == t.literal && type == t.type
    end

    def movement?
      @movement ||= [MOVEMENT, SUPERSET].include?(type)
    end

    def performance?
      @performance ||= [FAIL, LOAD, REP, SET].include?(type)
    end

    def to_s
      "[#{type}] #{literal}"
    end
  end
end
