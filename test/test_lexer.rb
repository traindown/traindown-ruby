require "minitest/autorun"
require "tdrb"

class LexerTest < Minitest::Test
  def test_chars
    traindown = "😠"
    lexer     = TDRB::Lexer.new(source: traindown)

    assert_equal(lexer.chars.count, 1)

    traindown = "g̈"
    lexer     = TDRB::Lexer.new(source: traindown)

    assert_equal(lexer.chars.count, 1)
  end
end
