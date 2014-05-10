require "test_helper"

class ComparedBasicTest < Minitest::Test
  def setup
    @reporter = McClimate::Reporter::ComparedBasic.new
  end

  def test_report_new_score
    @reporter.report_new_score("foo.rb", "#bar", 3)

    report = {"foo.rb" => {"#bar" => [3]}}
    assert_equal report, @reporter.report[:new]
  end

  def test_report_worse_score
    @reporter.report_worse_score("foo.rb", "#bar", 3, 1)

    report = {"foo.rb" => {"#bar" => [3, 1]}}
    assert_equal report, @reporter.report[:worse]
  end

  def test_report_fixed_score
    @reporter.report_fixed_score("foo.rb", "#bar", 3, 100)

    report = {"foo.rb" => {"#bar" => [3, 100]}}
    assert_equal report, @reporter.report[:fixed]
  end

  def test_report_improved_score
    @reporter.report_improved_score("foo.rb", "#bar", 30, 100)

    report = {"foo.rb" => {"#bar" => [30, 100]}}
    assert_equal report, @reporter.report[:improved]
  end
end
