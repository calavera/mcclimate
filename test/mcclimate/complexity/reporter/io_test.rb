require "test_helper"

class IOReporterTest < Minitest::Test
  require 'stringio'

  def setup
    @io = StringIO.new
    @reporter = McClimate::Reporter::IO.new(@io)
  end

  def test_notify_io
    @reporter.report_score(Pathname("foo"), "#bar", 3)
    @reporter.report_score(Pathname("foo"), "#baz", 1)
    @reporter.report_score(Pathname("bar"), "#baz", 20)

    @reporter.notify

    lines = @io.string.split("\n")
    assert_includes lines, "INFO: #bar in file foo has a complexity of 3"
    assert_includes lines, "INFO: #baz in file foo has a complexity of 1"
    assert_includes lines, "WARNING: #baz in file bar has a complexity of 20"
  end

  def test_notify_errors
    @reporter.report_error(StandardError.new("this is an error"))

    @reporter.notify

    assert_equal "ERROR: this is an error\n", @io.string
  end
end
