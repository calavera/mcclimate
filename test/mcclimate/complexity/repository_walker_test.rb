require "test_helper"

class RepositoryWalkerTest < Minitest::Test
  include Test::RepositoryHelper

  def setup
    @counter = 0
    @process = Proc.new {|path| @counter += 1}
  end

  def test_ignore_empty_paths
    repo   = new_tmp_repo
    walker = McClimate::RepositoryWalker.new(repo, "foo")
    walker.walk(repo, &@process)

    assert_equal 0, @counter
  end

  def test_process_common_ruby_files
    repo   = create_simple_repo
    walker = McClimate::RepositoryWalker.new(repo, "foo")
    walker.walk(repo, &@process)

    assert_equal 1, @counter
  end

  def test_process_deep_ruby_files
    repo   = create_deep_repo
    walker = McClimate::RepositoryWalker.new(repo, "foo")
    walker.walk(repo, &@process)

    assert_equal 1, @counter
  end
end
