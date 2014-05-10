require "test_helper"

class BasicReporterTest < Minitest::Test
  def setup
    @reporter = McClimate::Reporter::Basic.new
  end

  def test_keep_scores
    @reporter.report_score("foo", "bar", 3)

    result = {"foo" => {"bar" => 3}}
    assert_equal result, @reporter.total
  end

  def test_keep_errors
    @reporter.report_error(StandardError.new("this is an error"))
    assert_equal 1, @reporter.errors.size
  end
end
