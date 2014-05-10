module Test
  module CacheHelper
    def with_cache_env(&block)
      prev, ENV["MCCLIMATE_CACHE"] = ENV["MCCLIMATE_CACHE"], Dir.mktmpdir

      block.call
    ensure
      FileUtils.rm_rf(ENV["MCCLIMATE_CACHE"])
      ENV["MCCLIMATE_CACHE"] = prev
    end

    def put_cache(repo, sha, file_path, method_name, score)
      cache = McClimate::Cache.new(repo, sha)
      cache.put(file_path, method_name, score)
      cache.flush
    end
  end
end
