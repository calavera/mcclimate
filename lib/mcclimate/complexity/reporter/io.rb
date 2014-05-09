module McClimate
  module Reporter
    # IO reporter prints the report via an IO object, by default the standard output.
    class IO < Basic
      def initialize(io = STDOUT)
        super()
        @io = io
      end

      # Public: Sends the report information via the IO object.
      # It prints first the errors found parsing the repository.
      #
      # If the score is higher than 10, it prints a message "WARNING",
      # if the score is lower or equal to 10, it prints a message "INFO"
      def notify
        errors.each do |error|
          @io.puts "ERROR: #{error.message}"
        end

        total.each do |file, method_hash|
          method_hash.each do |method, score|
            prefix = score > 10 ? "WARNING:" : "INFO:"
            @io.puts "#{prefix} #{method} in file #{file} has a complexity of #{score}"
          end
        end
      end
    end
  end
end
