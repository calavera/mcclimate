module McClimate
  class Compare

    def initialize(reporter = Reporter::ComparedBasic.new)
      @reporter = reporter
    end

    # Public: Compares the score for two trees from the same repository.
    #
    # repo_path: is the path of the repo to compare.
    # old_sha: is the old sha to compare.
    # new_sha: is the new sha to compare.
    #
    # Returns nothing.
    def run(repo_path, old_sha, new_sha)
      repo = Pathname(repo_path)

      old_cache = McClimate::Cache.new(repo.basename, old_sha)
      new_cache = McClimate::Cache.new(repo.basename, new_sha)

      new_cache.all do |hit|
        if old_scores = old_cache.get(hit.file_path)
          compare_scores(old_scores, hit)
        else
          report_new_file(hit)
        end
      end
    end

    # Internal: Reports this hit as a new file in the repository.
    #
    # hit: is a Hit from the cache.
    #
    # Returns nothing.
    def report_new_file(hit)
      hit.each do |file_path, method_name, score|
        @reporter.report_new_score(file_path, method_name, score)
      end
    end

    # Internal: Compares two score caches and sends the results to the reporter
    #
    # old_scores: is the Hit in the old cache.
    # new_scores: is the Hit in the new cache.
    #
    # Returns nothing.
    def compare_scores(old_scores, new_scores)
      new_scores.each do |file_path, method_name, score|
        old_score = old_scores.cached_score[method_name]

        case
        when old_score.nil?
          @reporter.report_new_score(file_path, method_name, score)
        when score > old_score
          @reporter.report_worse_score(file_path, method_name, score, old_score)
        when old_score > 10 && score <= 10
          @reporter.report_fixed_score(file_path, method_name, score, old_score)
        when old_score > 10 && score < old_score
          @reporter.report_improved_score(file_path, method_name, score, old_score)
        end
      end
    end
  end
end
