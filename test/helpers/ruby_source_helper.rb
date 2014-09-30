module Test
  module RubySourceHelper
    DEFAULT_CONTENT = """class Foo
    def foo
    end
end
    """
    def new_ruby_source(path, content = DEFAULT_CONTENT)
      File.open(path, "w+") do |file|
        file.write content
      end

      path
    end
  end
end
