require "test_helper"

class MethodParserTest < Minitest::Test
  include Test::RepositoryHelper
  include Test::RubySourceHelper

  def setup
    @counter = 0
    @process = Proc.new {|file, sexp| @counter += 1}

    @parser = McClimate::MethodParser.new
  end

  def parse_definition(source)
    sexp = RubyParser.for_current_ruby.parse(source)
    McClimate::MethodParser::MethodDefinition.new(sexp)
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

  def test_method_definition_body
    source = "def foo; end"
    md = parse_definition(source)

    assert_equal RubyParser.for_current_ruby.parse(source), md.body
  end

  def test_method_definition_instance_name
    md = parse_definition("def foo; end")

    assert_equal "#foo", md.name
  end

  def test_method_definition_self_name
    md = parse_definition("def self.foo; end")

    assert_equal "self.foo", md.name
  end

  def test_method_definition_self_name
    md = parse_definition("def Foo.foo; end")

    assert_equal "Foo.foo", md.name
  end

  def test_method_definition_self_name
    md = parse_definition("def var.foo; end")

    assert_equal "var.foo", md.name
  end
end
