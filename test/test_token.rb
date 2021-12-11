require "minitest/autorun"
require "tdrb"

class TokenTest < Minitest::Test
  YOUR_MOM = "your mom".freeze

  def test_equals
    base, other =
      TDRB::Token::TOKEN_SYMBOLS
        .sample(2)
        .map { |ts| TDRB::Token.send(ts, YOUR_MOM) }

    assert_equal(base == other, false)

    other = TDRB::Token.new(literal: YOUR_MOM, type: base.type)
    assert_equal(base == other, true)

    other = TDRB::Token.new(literal: "not #{YOUR_MOM}", type: base.type)
    assert_equal(base == other, false)
  end

  def test_invalid_init
    assert_raises TDRB::TokenTypeError do
      TDRB::Token.new(literal: YOUR_MOM, type: YOUR_MOM)
    end
  end

  def test_movement?
    movement     = TDRB::Token.movement(YOUR_MOM)
    ss_movement  = TDRB::Token.superset(YOUR_MOM)
    not_movement = TDRB::Token.datetime(YOUR_MOM)

    assert_equal(movement.movement?, true)
    assert_equal(ss_movement.movement?, true)
    assert_equal(not_movement.movement?, false)
  end

  def test_named_constructors
    TDRB::Token::TOKEN_SYMBOLS.each do |sym|
      token = TDRB::Token.send(sym, YOUR_MOM)

      assert_equal(token.literal, YOUR_MOM)
      assert_equal(token.type, TDRB::Token.const_get(sym.upcase))
    end
  end

  def test_to_s
    TDRB::Token::TOKEN_SYMBOLS.each do |sym|
      token = TDRB::Token.send(sym, YOUR_MOM)

      assert_equal(token.to_s, "[#{token.type}] #{YOUR_MOM}")
    end
  end
end
