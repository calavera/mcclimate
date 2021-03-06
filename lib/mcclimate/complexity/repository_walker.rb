module McClimate
  # McClimate::RepositoryWalker iterates over the content inside
  # a directory to find the ruby files to analize.
  #
  # This search also walks inside nested directories.
  class RepositoryWalker
    BLACK_LIST = ["vendor"]

    def initialize(repo, sha)
      @repo       = Pathname(repo)

      @cache      = Cache.new(@repo.basename, sha)
      @parser     = MethodParser.new
      @calculator = ComplexityCalculator.new
    end

    # Public: Calculate the score for a repository and keep the results in the reporter
    #
    # reporter: is a structure where we keep the results for the repo and we use to notify after the process.
    #
    # Returns nothing
    def score(reporter)
      walk(@repo, reporter)
    ensure
      @cache.flush
    end

    # Public: Calculates the score for a file without hitting the cache.
    #
    # file_path: is the path to the file
    # reporter: is a structure where we keep the results for the repo and we use to notify after the process.
    #
    # Returns nothing.
    def calculate_score(file_path, reporter)
      @parser.walk(file_path) do |file, md|
        score = @calculator.score(md.body)
        @cache.put(file_path.to_path, md.name, score)

        reporter.report_score(file.to_path, md.name, score)
      end
    rescue MethodParser::Error => e
      reporter.report_error(e)
    end

    # Internal: Check the cache to see if the score is available there.
    #
    # file_path: is the path to the file
    # reporter: is a structure where we keep the results for the repo and we use to notify after the process.
    #
    # Returns false if there is no cached score.
    # Returns true if there is cached score
    def score_from_cache(file_path, reporter)
      cached_score = @cache.get(file_path.to_path)
      return false unless cached_score

      cached_score.each do |file, method_name, score|
        reporter.report_score(file, method_name, score)
      end

      true
    end

    # Internal: Walks over the entries in the directory given.
    #
    # dir: is the path to a directory in the file system.
    # reporter: is a structure where we keep the results for the repo and we use to notify after the process.
    #
    # Returns nothing.
    def walk(dir, reporter)
      dir.each_child do |child|
        next if black_listed?(child)

        walk_child(child, reporter)
      end
    end

    # Internal: Perform an operation with the directory child
    #
    # child: is the current child we're walking.
    # reporter: is a structure where we keep the results for the repo and we use to notify after the process.
    #
    # Returns nothing.
    def walk_child(child, reporter)
      walk(child, reporter) if child.directory?

      calculate_child_score(child, reporter) if ruby_source?(child)
    end

    def calculate_child_score(child, reporter)
      if !score_from_cache(child, reporter)
        calculate_score(child, reporter)
      end
    end

    # Internal: Decide whether the path is a ruby file or not.
    #
    # This is a really simplified check that only takes files ending with "*.rb" as ruby files.
    # There might be other ruby files, like Rakefile and gemspecs. We're leaving those files
    # intentionally out.
    #
    # path: is a string that might represent the path to a ruby file.
    #
    # Returns true if the path matches a ruby file.
    # Returns false otherwise
    def ruby_source?(path)
      path.to_s =~ /\.rb\Z/
    end

    # Internal: Whether the directory needs to be ignored or not.
    # There are certain directories that we don't want to analyze, like the vendor directory.
    #
    # child: the current element the walker is on.
    #
    # Returns true if the child needs to be ignored.
    # Returns false otherwize
    def black_listed?(child)
      BLACK_LIST.include?(child.basename.to_s)
    end
  end

  # AsyncRepositoryWalker is an specialization of RepositoryWalker
  # that uses Celluloid::Future to perform the score calculation for each file.
  class AsyncRepositoryWalker < RepositoryWalker
    include Celluloid

    # Internal: Overrides RepositoryWalker#walk to keep the list of futures.
    def walk(dir, reporter)
      futures = []

      dir.each_child do |child|
        next if black_listed?(child)

        futures << future.walk_child(child, reporter)
      end

      futures.each {|f| f.value}
    end
  end
end
