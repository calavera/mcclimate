require 'test_helper'

class ComplexityTest < Minitest::Test
  include Test::RepositoryHelper

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
end
