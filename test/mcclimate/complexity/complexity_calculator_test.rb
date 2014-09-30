require "test_helper"

class ComplexityCalculatorTest < Minitest::Test

  def setup
    @calc = McClimate::ComplexityCalculator.new
  end

  def parse(source)
    RubyParser.for_current_ruby.parse("def foo; #{source}; end")
  end

  def test_empty_method_source
    sexp = parse("")

    assert_equal 1, @calc.score(sexp)
  end

  def test_single_source
    sexp = parse("x = 1 + 1")

    assert_equal 4, @calc.score(sexp)
  end

  def test_basic_source
    sexp = parse("x = 1 + y * 2")

    assert_equal 5, @calc.score(sexp)
  end

  def test_complex_source
    sexp = parse("y = 3 + 3; x = 1 + y * 2")

    assert_equal 8, @calc.score(sexp)
  end

  def test_double_assign_source
    sexp = parse("x = 1 + (y = 3 + 3) * 2")

    assert_equal 11, @calc.score(sexp)
  end

  def test_ignore_symbolized_operators
    sexp = parse("a = :+")

    assert_equal 1, @calc.score(sexp)
  end

  def test_conditional_score
    sexp = parse("if (a = 1 + 1) == 2; end")

    assert_equal 4, @calc.score(sexp)
  end

  def test_while_score
    sexp = parse("while (a = 1 + 1) == 2; end")

    assert_equal 4, @calc.score(sexp)
  end
end
