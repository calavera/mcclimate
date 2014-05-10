require "test_helper"

class RepositoryWalkerTest < Minitest::Test
  include Test::RepositoryHelper

  class MockRepositoryWalker < McClimate::RepositoryWalker
    attr_reader :counter
    def initialize(repo, sha)
      super
      @counter = 0
    end

    def calculate_child_score(child, reporter)
      @counter += 1
    end
  end

  def setup
    @reporter = McClimate::Reporter::Basic.new
  end

  def test_ignore_empty_paths
    repo   = new_tmp_repo
    walker = MockRepositoryWalker.new(repo, "foo")
    walker.score(@reporter)

    assert_equal 0, walker.counter
  end

  def test_process_common_ruby_files
    repo   = create_simple_repo
    walker = MockRepositoryWalker.new(repo, "foo")
    walker.score(@reporter)

    assert_equal 1, walker.counter
  end

  def test_process_deep_ruby_files
    repo   = create_deep_repo
    walker = MockRepositoryWalker.new(repo, "foo")
    walker.score(@reporter)

    assert_equal 1, walker.counter
  end
end
