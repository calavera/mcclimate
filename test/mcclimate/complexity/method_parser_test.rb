require "test_helper"

class MethodParserTest < Minitest::Test
  include Test::RepositoryHelper
  include Test::RubySourceHelper

  def setup
    @counter = 0
    @process = Proc.new {|file, sexp| @counter += 1}

    @parser = McClimate::MethodParser.new
  end

  def test_ignore_empty_sources
    source = new_ruby_source("#{new_tmp_repo}/source.rb", "")

    @parser.walk(source, &@process)

    assert_equal 0, @counter
  end

  def test_count_method_definitions
    source = new_ruby_source("#{new_tmp_repo}/source.rb")

    @parser.walk(source, &@process)

    assert_equal 1, @counter
  end

  def test_raise_parser_error_with_wrong_ruby_sources
    path = "#{new_tmp_repo}/source.rb"
    source = new_ruby_source(path, "def foo")

    @parser.walk(source, &@process)
  rescue McClimate::MethodParser::Error => e
    assert_equal path, e.source
    assert e.message =~ /parse error on value "\$end/,
      "Expected message to include `parse error on value`, but was: #{e.message}"
  end
end
