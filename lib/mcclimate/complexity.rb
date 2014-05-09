module McClimate

  class InvalidRepository < ArgumentError
    def initialize(repo)
      super("Invalid git repository: #{repo}")
    end
  end

  # McClimate::Complexity calculates the McClimate complexity score for a given ruby source tree.
  class Complexity

    def initialize(reporter = Reporter::Basic.new)
      @reporter = reporter
    end

    # Public: Perform the calculation for a given repo.
    #
    # repo: is a directory path that points to a git repository.
    #
    # Returns nothing.
    def run(repo)
      verify_repository(repo)

      repo_walker = RepositoryWalker.new
      repo_walker.score(repo, @reporter)

      @reporter.notify
    end

    # Internal: Verify that the repository exists.
    # This validation should be check before performing any calculation.
    #
    # repo: is a directory path that points to a git repository.
    #
    # Raises a RepositoryError if the repository doesn't exist.
    def verify_repository(repo)
      valid = !repo.nil? && File.directory?(repo.strip)

      raise InvalidRepository.new(repo) unless valid
    end
  end
end
