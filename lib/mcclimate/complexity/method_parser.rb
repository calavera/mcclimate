module McClimate
  # McClimate::MethodParser parses a ruby file searching for method definitions.
  # Then iterates each definition looking for asignments to calculate their complexity.
  class MethodParser

    class Error < StandardError
      attr_reader :source

      def initialize(source, error)
        @source = source
        super("ERROR: #{source} cannot be processed, the syntax is invalid: #{error.message}")
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
        block.call(file, definition)
      end
    rescue Racc::ParseError => e
      raise Error.new(source, e)
    end
  end
end
