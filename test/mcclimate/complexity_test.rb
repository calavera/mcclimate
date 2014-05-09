require 'test_helper'

class ComplexityTest < Minitest::Test
  def setup
    @complexity = McClimate::Complexity.new
  end

  def test_abort_run_with_invalid_repository
    assert_raises(McClimate::InvalidRepository) do
      @complexity.run(nil)
    end

    assert_raises(McClimate::InvalidRepository) do
      @complexity.run("  ")
    end

    assert_raises(McClimate::InvalidRepository) do
      @complexity.run("foo/bar/baz")
    end
  end

  def test_runs_with_valid_repository
    @complexity.run(Dir.mktmpdir)
  rescue McClimate::InvalidRepository
    refute true, "Unexpected repository validation"
  end
end
