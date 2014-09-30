require "test_helper"

class ComparedResultsTest < Minitest::Test
  def setup
    @io = StringIO.new
    @reporter = McClimate::Reporter::ComparedResults.new(@io)
  end

  def output
    @io.string.chomp
  end

  def test_report_new_score
    @reporter.report_new_score("foo.rb", "#bar", 3)

    assert_equal "NEW: '#bar' in foo.rb has a complexity of 3.", output
  end

  def test_report_worse_score
    @reporter.report_worse_score("foo.rb", "#bar", 3, 1)

    assert_equal "WORSE: '#bar' in foo.rb has a complexity of 3 (was 1).", output
  end

  def test_report_fixed_score
    @reporter.report_fixed_score("foo.rb", "#bar", 3, 100)

    assert_equal "FIXED: '#bar' in foo.rb has a complexity of 3 (was 100).", output
  end

  def test_report_improved_score
    @reporter.report_improved_score("foo.rb", "#bar", 30, 100)

    assert_equal "IMPROVED: '#bar' in foo.rb has a complexity of 30 (was 100).", output
  end
end
