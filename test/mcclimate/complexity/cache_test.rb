require "test_helper"

class CacheTest < Minitest::Test
  def default_cache
    Pathname(Dir.tmpdir).join("mcclimate-cache")
  end

  def without_cache_env(&block)
    prev, ENV["MCCLIMATE_CACHE"] = ENV["MCCLIMATE_CACHE"], nil

    block.call
  ensure
    ENV["MCCLIMATE_CACHE"] = prev
  end

  def test_default_location
    without_cache_env do
      cache = McClimate::Cache.new("foo", "bar")
      assert_equal default_cache, cache.location
    end
  end

  def test_custom_location
    prev, ENV["MCCLIMATE_CACHE"] = ENV["MCCLIMATE_CACHE"], "#{Dir.tmpdir}/bar"

    cache = McClimate::Cache.new("foo", "bar")
    assert_equal Pathname("#{Dir.tmpdir}/bar"), cache.location
  ensure
    ENV["MCCLIMATE_CACHE"] = prev
  end

  def test_cache_initialization
    without_cache_env do
      loc = default_cache.join("foo", "bar")
      McClimate::Cache.new("foo", "bar")

      assert loc.exist?, "Expected repo/sha cache to exist in #{loc.to_path}"
    end
  end

  def test_put_in_cache
    without_cache_env do
      cache = McClimate::Cache.new("foo", "bar")
      score = cache.put("file_name", "method", 3)

      assert_equal 3, score
    end
  end

  def test_get_from_cache
    without_cache_env do
      cache = McClimate::Cache.new("foo", "bar")
      cache.put("file_name", "method", 3)

      hit = cache.get("file_name")
      hit.each do |file_name, method_name, score|
        assert_equal 3, score
        assert_equal "method", method_name
      end
    end
  end

  def test_flush_cache
    without_cache_env do
      cache = McClimate::Cache.new("foo", "bar")
      cache.put("file_name", "method", 3)
      cache.flush


      assert default_cache.join("foo", "bar", Digest::MD5.hexdigest("file_name")).exist?,
        "Expected to have dumped the cached score in disk"
    end
  end

  def test_get_from_disk_cache
    without_cache_env do
      cache = McClimate::Cache.new("foo", "bar")
      cache.put("file_name", "method", 3)
      cache.flush

      cache2 = McClimate::Cache.new("foo", "bar")
      hit = cache2.get("file_name")
      assert hit, "Expected to hit the disk cache"

      hit.each do |file_name, method_name, score|
        assert_equal 3, score
        assert_equal "method", method_name
      end
    end
  end

  def test_get_all_cached_scores
    without_cache_env do
      cache = McClimate::Cache.new("foo", "bar")
      cache.put("file_name", "method", 3)
      cache.flush

      cache2 = McClimate::Cache.new("foo", "bar")
      cache2.all do |hit|
        hit.each do |file_name, method_name, score|
          assert_equal 3, score
          assert_equal "method", method_name
        end
      end
    end
  end
end
