module McClimate
  # McClimate::MethodParser parses a ruby file searching for method definitions.
  # Then iterates each definition looking for asignments to calculate their complexity.
  class MethodParser

    # Error raised when a ruby source cannot be parsed.
    # The repository walker need to handle this error, probably adding it to the reporter.
    class Error < StandardError
      attr_reader :source

      def initialize(source, error)
        @source = source
        super("#{source} cannot be processed, the syntax is invalid: #{error.message}")
      end
    end

    # MethodDefinition keeps the parse tree for a method.
    # It's also a helper to cache the method name and other properties that we can extract from the tree.
    class MethodDefinition
      attr_reader :body

      def initialize(sexp)
        @body = sexp
      end

      # Public: Extract the method name from the definition tree.
      #
      # By default, the name is in the second position in the tree.
      # If the method is a class method or a variable method, the name is in the third position.
      # The second position is a tree that identifies the type of method.
      #
      # Returns the method name for a definition.
      #
      # Examples:
      #
      # > MethodDefinition.new(s("def foo; end")).name
      # => "#foo"
      #
      # > MethodDefinition.new(s("def self.foo; end")).name
      # => "self.foo"
      #
      # > MethodDefinition.new(s("def Foo.foo; end")).name
      # => "Foo.foo"
      #
      # > MethodDefinition.new(s("def var.foo; end")).name
      # => "var.foo"
      def name
        @name ||= begin
          prefix = "#"
          name = @body[1]

          if name.is_a?(Sexp)
            if name.first == :lvar
              prefix = name.last.to_s + "#"
            else
              prefix = name.last.to_s + "."
            end

            name = @body[2]
          end

          prefix + name.to_s
        end
      end
    end

    # Public: Parse a ruby source file and execute a block for each method definition found.
    #
    # source: is the path to a ruby source file.
    # block: is the action to perform for each method definition.
    #
    # Returns nothing.
    def walk(source, &block)
      file = File.open(source)

      sexp = RubyParser.for_current_ruby.parse(file.read)
      return if sexp.nil? # the source is empty

      sexp.each_of_type(:defn) do |definition|
        block.call(file, MethodDefinition.new(definition))
      end
    rescue Racc::ParseError => e
      raise Error.new(source, e)
    end
  end
end
