require "test_helper"

class RepositoryWalkerTest < Minitest::Test
  include Test::RepositoryHelper

  def setup
    @counter = 0
    @process = Proc.new {|path| @counter += 1}

    @walker = McClimate::RepositoryWalker.new
  end

  def test_ignore_empty_paths
    @walker.walk(new_tmp_repo, &@process)

    assert_equal 0, @counter
  end

  def test_process_common_ruby_files
    @walker.walk(create_simple_repo, &@process)

    assert_equal 1, @counter
  end

  def test_process_deep_ruby_files
    @walker.walk(create_deep_repo, &@process)

    assert_equal 1, @counter
  end
end
