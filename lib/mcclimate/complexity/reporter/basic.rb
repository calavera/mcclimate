module McClimate
  module Reporter
    # Basic reporter stores the store results in a hash table to inspect later.
    # Other reporters might extend this one to override the `notify` method.
    class Basic
      attr_reader :total, :errors

      def initialize
        @total = {}
        @errors = []
      end

      # Public: Adds the score for a given file and method to the report.
      #
      # file: is the path to the source file.
      # method_name: is the name for the method.
      # score: is the complexity score.
      #
      # Returns nothing
      def report_score(file, method_name, score)
        @total[file.to_path] ||= {}
        @total[file.to_path][method_name] = score
      end

      # Public: Adds the error to the accumulator.
      # Other reporters might override this method to handle errors differently.
      #
      # error: is an object that responds to `message`.
      #
      # Returns nothing.
      def report_error(error)
        @errors << error
      end

      # Public: Notify the total result.
      # Other reporters can override this method to add more complexity.
      #
      # Returns the report.
      def notify
        @total
      end
    end
  end
end
