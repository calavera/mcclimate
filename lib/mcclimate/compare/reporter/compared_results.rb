module McClimate
  module Reporter
    # ComparedResults reporter prints the report via an IO object, by default the standard output.
    # It's used when we compare the complexity of two different trees.
    class ComparedResults
      def initialize(io = STDOUT)
        @io = io
      end

      # Public: Report a new method in the repository.
      #
      # file_path: is the path to the file that includes that method.
      # method_name: is the name of the method.
      # score: is the complexity score.
      #
      # Returns nothing.
      def report_new_score(file_path, method_name, score)
        @io.puts "NEW: '#{method_name}' in #{file_path} has a complexity of #{score}."
      end

      # Public: Reports when a method score is worse than the old one.
      #
      # file_path: is the path to the file that includes that method.
      # method_name: is the name of the method.
      # score: is the complexity score.
      #
      # Returns nothing.
      def report_worse_score(file_path, method_name, score, old_score)
        @io.puts "WORSE: '#{method_name}' in #{file_path} has a complexity of #{score} (was #{old_score})."
      end

      # Public: Reports when a method as been fixed.
      # It means that the new score is lower than the old one and lower than 10.
      #
      # file_path: is the path to the file that includes that method.
      # method_name: is the name of the method.
      # score: is the complexity score.
      #
      # Returns nothing.
      def report_fixed_score(file_path, method_name, score, old_score)
        @io.puts "FIXED: '#{method_name}' in #{file_path} has a complexity of #{score} (was #{old_score})."
      end

      # Public: Reports when a method as improved.
      # It means that the new score is lower than the old one, but still higher than 10.
      #
      # file_path: is the path to the file that includes that method.
      # method_name: is the name of the method.
      # score: is the complexity score.
      #
      # Returns nothing.
      def report_improved_score(file_path, method_name, score, old_score)
        @io.puts "IMPROVED: '#{method_name}' in #{file_path} has a complexity of #{score} (was #{old_score})."
      end
    end
  end
end
