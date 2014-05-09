module McClimate
  # McClimate calculates the complexity score for a given method definition.
  class ComplexityCalculator

    OPERATORS = [:+, :-, :*, :/]

    # Public: Calculate the complexity score for a method definition.
    #
    # sexp: is the method definition in Sexp format.
    #
    # Returns the method score as an integer.
    # The minimum score for a method is 1, even if it's empty.
    def score(sexp)
      score = 1

      sexp.each_of_type(:lasgn) do |asgn|
        asgn.deep_each do |elem|
          score += 1 if OPERATORS.include?(elem) || literal?(elem)
          score += count_call_operators(elem)
        end
      end

      score
    end

    # Internal: Count operators inside call trees.
    #
    # elem: is a call tree.
    #
    # Returns the number of operators found in this call.
    def count_call_operators(elem)
      a = elem.to_a
      return 0 if a[0] != :call

      a.count {|e| OPERATORS.include?(e)}
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
