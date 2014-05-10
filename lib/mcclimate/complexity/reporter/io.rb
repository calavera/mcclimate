module McClimate
  module Reporter
    # IO reporter prints the report via an IO object, by default the standard output.
    class IO
      def initialize(io = STDOUT)
        @io = io
      end

      # Public: Sends the report information via the IO object.
      # It prints first the errors found parsing the repository.
      #
      # file_path: is the path to the source file.
      # method_name: is the name for the method.
      # score: is the complexity score.
      #
      # If the score is higher than 10, it prints a message "WARNING",
      # if the score is lower or equal to 10, it prints a message "INFO"
      def report_score(file_path, method_name, score)
        prefix = score > 10 ? "WARNING:" : "INFO:"
        @io.puts "#{prefix} '#{method_name}' in file #{file_path} has a complexity of #{score}"
      end

      # Public: Adds the error to the accumulator.
      # Other reporters might override this method to handle errors differently.
      #
      # error: is an object that responds to `message`.
      #
      # Returns nothing.
      def report_error(error)
        @io.puts "ERROR: #{error.message}"
      end
    end
  end
end
