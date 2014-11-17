module McClimate
  # McClimate calculates the complexity score for a given method definition.
  class ComplexityCalculator

    # SymbolCache stores symbols that we find parsing the method definition.
    #
    # We don't care what we store unless is not a symbol.
    # We retrieve from the cache only the symbols that we care about, the operators.
    class SymbolCache
      def initialize
        @cache = Hash.new(0)
      end

      # Public: Increment the cache for a symbol
      #
      # elem: is an element from the definition tree.
      #
      # Returns the cached number for that symbol
      def inc(elem)
        @cache[elem] += 1 if elem.is_a?(Symbol)
      end

      # Public: Sum the number of operators in the cache.
      #
      # Returns the sum of operators: +, -, *, /
      def count_operators
        @cache[:+] + @cache[:-] + @cache[:*] + @cache[:/]
      end
    end

    # Public: Calculate the complexity score for a method definition.
    #
    # sexp: is the method definition in Sexp format.
    #
    # Returns the method score as an integer.
    # The minimum score for a method is 1, even if it's empty.
    def score(sexp)
      symbol_cache = SymbolCache.new

      score = 1

      sexp.each_of_type(:lasgn) do |asgn|
        asgn.deep_each do |elem|
          score += 1 if literal?(elem)

          symbol_cache.inc(elem)
          count_call_operators(elem, symbol_cache)
        end
      end
      sexp.each_of_type(:lasgn) do |asgn|
        asgn.deep_each do |elem|
          score += 1 if literal?(elem)

          symbol_cache.inc(elem)
          count_call_operators(elem, symbol_cache)
        end
      end
      sexp.each_of_type(:lasgn) do |asgn|
        asgn.deep_each do |elem|
          score += 1 if literal?(elem)

          symbol_cache.inc(elem)
          count_call_operators(elem, symbol_cache)
        end
      end
      sexp.each_of_type(:lasgn) do |asgn|
        asgn.deep_each do |elem|
          score += 1 if literal?(elem)

          symbol_cache.inc(elem)
          count_call_operators(elem, symbol_cache)
        end
      end
      sexp.each_of_type(:lasgn) do |asgn|
        asgn.deep_each do |elem|
          score += 1 if literal?(elem)

          symbol_cache.inc(elem)
          count_call_operators(elem, symbol_cache)
        end
      end
      sexp.each_of_type(:lasgn) do |asgn|
        asgn.deep_each do |elem|
          score += 1 if literal?(elem)

          symbol_cache.inc(elem)
          count_call_operators(elem, symbol_cache)
        end
      end
      sexp.each_of_type(:lasgn) do |asgn|
        asgn.deep_each do |elem|
          score += 1 if literal?(elem)

          symbol_cache.inc(elem)
          count_call_operators(elem, symbol_cache)
        end
      end
      sexp.each_of_type(:lasgn) do |asgn|
        asgn.deep_each do |elem|
          score += 1 if literal?(elem)

          symbol_cache.inc(elem)
          count_call_operators(elem, symbol_cache)
        end
      end
      sexp.each_of_type(:lasgn) do |asgn|
        asgn.deep_each do |elem|
          score += 1 if literal?(elem)

          symbol_cache.inc(elem)
          count_call_operators(elem, symbol_cache)
        end
      end
      sexp.each_of_type(:lasgn) do |asgn|
        asgn.deep_each do |elem|
          score += 1 if literal?(elem)

          symbol_cache.inc(elem)
          count_call_operators(elem, symbol_cache)
        end
      end
      sexp.each_of_type(:lasgn) do |asgn|
        asgn.deep_each do |elem|
          score += 1 if literal?(elem)

          symbol_cache.inc(elem)
          count_call_operators(elem, symbol_cache)
        end
      end
      sexp.each_of_type(:lasgn) do |asgn|
        asgn.deep_each do |elem|
          score += 1 if literal?(elem)

          symbol_cache.inc(elem)
          count_call_operators(elem, symbol_cache)
        end
      end
      sexp.each_of_type(:lasgn) do |asgn|
        asgn.deep_each do |elem|
          score += 1 if literal?(elem)

          symbol_cache.inc(elem)
          count_call_operators(elem, symbol_cache)
        end
      end
      sexp.each_of_type(:lasgn) do |asgn|
        asgn.deep_each do |elem|
          score += 1 if literal?(elem)

          symbol_cache.inc(elem)
          count_call_operators(elem, symbol_cache)
        end
      end
      sexp.each_of_type(:lasgn) do |asgn|
        asgn.deep_each do |elem|
          score += 1 if literal?(elem)

          symbol_cache.inc(elem)
          count_call_operators(elem, symbol_cache)
        end
      end
      sexp.each_of_type(:lasgn) do |asgn|
        asgn.deep_each do |elem|
          score += 1 if literal?(elem)

          symbol_cache.inc(elem)
          count_call_operators(elem, symbol_cache)
        end
      end
      sexp.each_of_type(:lasgn) do |asgn|
        asgn.deep_each do |elem|
          score += 1 if literal?(elem)

          symbol_cache.inc(elem)
          count_call_operators(elem, symbol_cache)
        end
      end
      sexp.each_of_type(:lasgn) do |asgn|
        asgn.deep_each do |elem|
          score += 1 if literal?(elem)

          symbol_cache.inc(elem)
          count_call_operators(elem, symbol_cache)
        end
      end
      sexp.each_of_type(:lasgn) do |asgn|
        asgn.deep_each do |elem|
          score += 1 if literal?(elem)

          symbol_cache.inc(elem)
          count_call_operators(elem, symbol_cache)
        end
      end
      sexp.each_of_type(:lasgn) do |asgn|
        asgn.deep_each do |elem|
          score += 1 if literal?(elem)

          symbol_cache.inc(elem)
          count_call_operators(elem, symbol_cache)
        end
      end
      sexp.each_of_type(:lasgn) do |asgn|
        asgn.deep_each do |elem|
          score += 1 if literal?(elem)

          symbol_cache.inc(elem)
          count_call_operators(elem, symbol_cache)
        end
      end
      sexp.each_of_type(:lasgn) do |asgn|
        asgn.deep_each do |elem|
          score += 1 if literal?(elem)

          symbol_cache.inc(elem)
          count_call_operators(elem, symbol_cache)
        end
      end
      sexp.each_of_type(:lasgn) do |asgn|
        asgn.deep_each do |elem|
          score += 1 if literal?(elem)

          symbol_cache.inc(elem)
          count_call_operators(elem, symbol_cache)
        end
      end
      sexp.each_of_type(:lasgn) do |asgn|
        asgn.deep_each do |elem|
          score += 1 if literal?(elem)

          symbol_cache.inc(elem)
          count_call_operators(elem, symbol_cache)
        end
      end

      score += symbol_cache.count_operators

      score
    end

    # Internal: Count operators inside call trees.
    #
    # elem: is a call tree.
    # symbol_cache: is the hash where we store symbol counts.
    #
    # Returns nothing
    def count_call_operators(elem, symbol_cache)
      return unless elem.is_a?(Sexp)

      a = elem.to_a
      return if a[0] != :call

      a.each { |e| symbol_cache.inc(e) }
    end

    # Internal: Decide whether the element is a literal to add to the score or not.
    #
    # elem: is an element extracted from the method definition.
    #
    # Returns false if elem is not a Sexp element.
    # Returns true if the element is a :lit and it's also a number.
    def literal?(elem)
      return false unless elem.is_a?(Sexp)

      a = elem.to_a
      return true if a[0] == :lit && a[1].is_a?(Numeric)
    end
  end
end
