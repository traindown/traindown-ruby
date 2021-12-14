module TDRB
  ##
  # Parser is the thing that does STUFF to a Token stream. What stuff? Well,
  # that is defined by the handler lambdas.

  class Parser
    attr_reader :lexer, :traindown

    def initialize(traindown:)
      @lexer     = Lexer.new(source: traindown, state: IDLE)
      @traindown = traindown
    end

    def tokens
      lexer.run
      lexer.tokens
    end

    class << self
      def colon_terminator?(char)
        char == ":" || char == Token::EOF
      end

      def line_terminator?(char)
        return true if char == Token::EOF

        cp = char.codepoints;

        return true if cp.empty?
        return true if cp.count == 1 && [0, 10, 13, 59].include?(cp.first)
        return true if cp.count == 2 && cp.first == 13 and cp.last == 10

        false
      end

      def whitespace?(char)
        char.strip.empty?
      end
    end

    IDLE = lambda do |lexer|
      char = lexer.peek
      return if char == Token::EOF

      if whitespace?(char) || line_terminator?(char)
        lexer.next_char
        lexer.ignore

        return IDLE
      end

      case char
      when "@" then DATETIME
      when "#" then METAKEY
      when "*" then NOTE
      else
        VALUE
      end
    end

    DATETIME = lambda do |lexer|
      lexer.take(["@", " "])
      lexer.ignore

      char = lexer.next_char

      while !line_terminator?(char) do
        char = lexer.next_char
      end

      lexer.rewind
      lexer.emit(Token::DATETIME)

      IDLE
    end

    METAKEY = lambda do |lexer|
      lexer.take(["#", " "])
      lexer.ignore

      char = lexer.next_char

      while !colon_terminator?(char) do
        char = lexer.next_char
      end

      lexer.rewind
      lexer.emit(Token::METAKEY)

      METAVALUE
    end

    METAVALUE = lambda do |lexer|
      lexer.take([":", " "])
      lexer.ignore

      char = lexer.next_char

      while !line_terminator?(char) do
        char = lexer.next_char
      end

      lexer.rewind
      lexer.emit(Token::METAVALUE)

      IDLE
    end

    # register_state :movement do
    # end

    MOVEMENT = lambda do |lexer|
      superset = false;

      char = lexer.next_char

      return if char == Token::EOF

      if char == "+"
        superset = true
        lexer.take([" "])
        lexer.ignore
        char = lexer.next_char
      end

      if char == "'"
        lexer.ignore
        char = lexer.next_char
      end

      while !colon_terminator?(char) do
        char = lexer.next_char
      end

      lexer.rewind

      if (superset)
        lexer.emit(Token::SUPERSET)
      else
        lexer.emit(Token::MOVEMENT)
      end

      lexer.take([":"])
      lexer.ignore

      IDLE
    end

    NOTE = lambda do |lexer|
      lexer.take(["*", " "])
      lexer.ignore

      char = lexer.next_char

      while !line_terminator?(char) do
        char = lexer.next_char
      end

      lexer.rewind
      lexer.emit(Token::NOTE)

      IDLE
    end

    NUMBER = lambda do |lexer|
      lexer.take(["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "."])

      # TODO: Configurable chars
      case lexer.peek
      when "f", "F" then lexer.emit(Token::FAIL)
      when "r", "R" then lexer.emit(Token::REP)
      when "s", "S" then lexer.emit(TokenType::SET)
      else
        lexer.emit(Token::LOAD)
      end

      lexer.take(["f", "F", "r", "R", "s", "S"])
      lexer.ignore

      IDLE
    end

    VALUE = lambda do |lexer|
      char = lexer.next_char

      if char == "+" || char == "'"
        lexer.rewind
        return MOVEMENT
      end

      begin
        !!Integer(char)
        return NUMBER
      rescue ArgumentError, TypeError
        nil
      end

      if char != "b" && char != "B"
        lexer.rewind
        return MOVEMENT
      end

      peek = lexer.peek

      if peek != "w" && peek != "W"
        lexer.rewind
        MOVEMENT
      end

      while !whitespace?(char)
        char = lexer.next_char
      end

      lexer.rewind
      lexer.emit(Token::LOAD)

      IDLE
    end
  end
end
