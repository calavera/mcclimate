require "test_helper"

class CompareTest < Minitest::Test
  include Test::CacheHelper

  def setup
    @repo = "foo"
    @old_sha = "A" * 40
    @new_sha = "B" * 40

    @reporter = McClimate::Reporter::ComparedBasic.new
    @compare  = McClimate::Compare.new(@reporter)
  end

  def test_reports_new_files_when_old_cache_is_empty
    with_cache_env do
      put_cache(@repo, @new_sha, "foo.rb", "#bar", 3)

      @compare.run(@repo, @old_sha, @new_sha)

      report = {"foo.rb" => {"#bar" => [3]}}
      assert_equal report, @reporter.report[:new]
    end
  end

  def test_reports_worse_score
    with_cache_env do
      put_cache(@repo, @old_sha, "foo.rb", "#bar", 3)
      put_cache(@repo, @new_sha, "foo.rb", "#bar", 30)

      @compare.run(@repo, @old_sha, @new_sha)

      report = {"foo.rb" => {"#bar" => [30, 3]}}
      assert_equal report, @reporter.report[:worse]
    end
  end

  def test_reports_fixed_score
    with_cache_env do
      put_cache(@repo, @old_sha, "foo.rb", "#bar", 30)
      put_cache(@repo, @new_sha, "foo.rb", "#bar", 3)

      @compare.run(@repo, @old_sha, @new_sha)

      report = {"foo.rb" => {"#bar" => [3, 30]}}
      assert_equal report, @reporter.report[:fixed]
    end
  end

  def test_reports_fixed_score_limit
    with_cache_env do
      put_cache(@repo, @old_sha, "foo.rb", "#bar", 30)
      put_cache(@repo, @new_sha, "foo.rb", "#bar", 10)

      @compare.run(@repo, @old_sha, @new_sha)

      report = {"foo.rb" => {"#bar" => [10, 30]}}
      assert_equal report, @reporter.report[:fixed]
    end
  end

  def test_reports_improved_score
    with_cache_env do
      put_cache(@repo, @old_sha, "foo.rb", "#bar", 30)
      put_cache(@repo, @new_sha, "foo.rb", "#bar", 11)

      @compare.run(@repo, @old_sha, @new_sha)

      report = {"foo.rb" => {"#bar" => [11, 30]}}
      assert_equal report, @reporter.report[:improved]
    end
  end
end
