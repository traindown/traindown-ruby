module TDRB
  class Lexer
    attr_reader :source, :tokens

    def initialize(source:, state: -> (_) {})
      @col    = 0
      @line   = 0
      @pos    = 0
      @source = source
      @stack  = []
      @start  = 0
      @state  = state
      @tokens = []
    end

    def chars
      @chars ||= source.grapheme_clusters
    end

    def current
      chars[@start..]
        .take(@pos - @start)
        .join
    end

    def emit(token_type)
      tokens << Token.new(literal: current, type: token_type)

      @start = @pos
      @stack = []
    end

    def ignore
      @stack = []
      @start = @pos
    end

    def next_char
      return @stack << Token::EOF && Token::EOF if chars.count.pred == @start

      sub_source = source[@pos..]
      @pos += 1

      return @stack << Token::EOF && Token::EOF if sub_source.empty?

      @stack << sub_source[0] && sub_source[0]
    end

    def peek
      char = next_char
      rewind

      char
    end

    def pop_stack
      @stack.pop || TDRB::Token::EOF
    end

    def rewind
      char = pop_stack
      @pos -= 1 if char != Token::EOF
      @pos = @start if (@pos < @start)
    end

    def run
      while @state do
        @state = @state.call(self)
      end

      true
    end

    def take(characters)
      char = next_char
      while characters.include?(char) do
        char = next_char
      end

      rewind
    end
  end
end
