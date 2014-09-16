module McClimate

  class InvalidRepository < ArgumentError
    def initialize(repo, sha = nil, error = nil)
      message = "Invalid git repository: #{repo}"
      message << " at #{sha}" if sha
      message << ":\n #{error.message}" if error

      super(message)
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
    # sha: is the git SHA to checkout before checking the repository score.
    #
    # Returns nothing.
    def run(repo, sha = nil)
      verify_repository(repo, sha)

      head = checkout_repository(repo, sha)

      repo_walker = AsyncRepositoryWalker.new(repo, head)
      repo_walker.score(@reporter)
    end

    # Internal: Verify that the repository exists.
    # This validation should be check before performing any calculation.
    #
    # repo: is a directory path that points to a git repository.
    #
    # Raises a RepositoryError if the repository doesn't exist.
    def verify_repository(repo, sha = nil)
      valid = !repo.nil? && File.directory?(repo.strip)

      raise InvalidRepository.new(repo) unless valid
    end

    # Public: Read the current SHA for the repository.
    # It checks out a specific SHA if it exists.
    #
    # sha: is the git SHA to checkout.
    #
    # Returns the current SHA in the HEAD.
    def checkout_repository(repo, sha = nil)
      git_repo = Rugged::Repository.new(repo)

      if sha
        unless git_repo.exists?(sha)
          raise InvalidRepository.new(repo, sha)
        end

        git_repo.checkout(sha, strategy: :force)
      end

      git_repo.last_commit.oid
    rescue Rugged::OSError, Rugged::RepositoryError => e
      raise InvalidRepository.new(repo, sha, e)
    end
  end
end
