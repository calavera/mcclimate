module McClimate
  module Reporter
    # ComparedBasic defines the interface that a reporter needs to fullfil to
    # be able to use it when comparing the complexity of two different trees.
    class ComparedBasic
      attr_reader :report

      def initialize
        @report = {}
      end

      # Public: Report a new method in the repository.
      #
      # file_path: is the path to the file that includes that method.
      # method_name: is the name of the method.
      # score: is the complexity score.
      #
      # Returns nothing.
      def report_new_score(file_path, method_name, score)
        keep(:new, file_path, method_name, score)
      end

      # Public: Reports when a method score is worse than the old one.
      #
      # file_path: is the path to the file that includes that method.
      # method_name: is the name of the method.
      # score: is the complexity score.
      #
      # Returns nothing.
      def report_worse_score(file_path, method_name, score, old_score)
        keep(:worse, file_path, method_name, score, old_score)
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
        keep(:fixed, file_path, method_name, score, old_score)
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
        keep(:improved, file_path, method_name, score, old_score)
      end

      # Internal: Keep a deep hash with the values reported.
      #
      # key: is the kind of report.
      # args: is a variable number of arguments representing the report.
      #
      # Returns nothing.
      def keep(key, *args)
        @report[key] ||= {}
        @report[key][args[0]] ||= {}
        @report[key][args[0]][args[1]] = args[2..-1]
      end
    end
  end
end
