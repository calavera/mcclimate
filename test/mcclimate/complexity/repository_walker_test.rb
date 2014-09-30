require "test_helper"

class RepositoryWalkerTest < Minitest::Test
  include Test::RepositoryHelper
  include Test::CacheHelper

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
    @simple_walker = McClimate::RepositoryWalker.new(new_tmp_repo, "foo")
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

  def test_blacklist_vendor_dir
    assert @simple_walker.black_listed?(Pathname("vendor")),
      "Expected to blacklist the vendor directory"
  end

  def test_do_not_blacklist_any_other_dir
    refute @simple_walker.black_listed?(Pathname("foo")),
      "Expected to not blacklist a random directory"
  end

  def test_ruby_source
    assert @simple_walker.ruby_source?("foo.rb"),
      "Expected to be a ruby source"
  end

  def test_refute_ruby_source
    refute @simple_walker.ruby_source?("Gemfile"),
      "Expected to not be a ruby source"
  end

  def test_score_from_cache_miss
    refute @simple_walker.score_from_cache(Pathname("foo.rb"), nil),
      "Expected to not get the score from the cache"
  end

  def test_score_from_cache_hit
    with_cache_env do
      repo  = new_tmp_repo
      path = Pathname(repo)
      put_cache(path.basename, "foo", "foo.rb", "#bar", 3)

      reporter = McClimate::Reporter::Basic.new
      walker   = McClimate::RepositoryWalker.new(repo, "foo")

      assert walker.score_from_cache(Pathname("foo.rb"), reporter),
        "Expected to get the score from the cache"
    end
  end
end
