module TDRB
  class Error < StandardError
  end

  class ParseError < Error
  end

  class TokenArgsError < Error
  end

  class TokenError < Error
  end

  class TokenTypeError < Error
  end
end
