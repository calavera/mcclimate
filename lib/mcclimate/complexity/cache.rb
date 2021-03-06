module McClimate
  # Cache store complexity scores into serialized files.
  #
  # By default it stores the cache in the system's temporal directory.
  # Use the environment variable `MCCLIMATE_CACHE` to change the destination of the cache.
  class Cache
    class Hit
      attr_reader :file_path, :cached_score

      def initialize(file_path, cached_score)
        @file_path, @cached_score = file_path, cached_score
      end

      # Public: Iterate over each method score and send it to the block given.
      # This method doesn't do anything if there is no block given.
      #
      # Returns nothing.
      def each(&block)
        return unless block_given?

        @cached_score.each do |method_name, score|
          block.call(@file_path, method_name, score)
        end
      end
    end

    def initialize(repo, sha)
      @repo, @sha = repo, sha

      @cache      = {}

      @disk_cache = location.join(@repo, @sha)
      @disk_cache.mkpath
    end

    # Public: Get every hit in the cache.
    #
    # block: is an action do to for each hit in the cache.
    #
    # Returns nothing.
    def all(&block)
      @disk_cache.each_child do |child|
        file_path, method_cache = load_cache(child)
        block.call(Hit.new(file_path, method_cache))
      end
    end

    # Public: Get the score for a source file from the cache.
    #
    # It hits the hot cache first to see if it loaded.
    # It tries to load the cached serialized file if it's not in the hot cache.
    #
    # file_path: is the path to a source file that should be in the cache.
    #
    # Returns nil if the file is not in the cache.
    # Returns a new Hit if the file is in the cache.
    def get(file_path)
      hit = @cache[file_path]
      return Hit.new(file_path, hit) if hit

      disk_file = disk_cached_file(file_path)

      if disk_file.exist?
        _, method_cache = load_cache(disk_file)
        return Hit.new(file_path, method_cache)
      end
    end

    # Public: Put the score value for a method in the cache.
    #
    # file_path: is the path to a source file that should be in the cache.
    # method_name: is the name of the method.
    # score: is the complexity score.
    #
    # Returns the score set in cache.
    def put(file_path, method_name, score)
      @cache[file_path] ||= {}
      @cache[file_path][method_name] = score
    end

    # Public: Serializes the hot cache into the file system.
    # If this method is not called, the cache disappears when the process exits.
    #
    # Returns nothing.
    def flush
      @cache.each do |file_path, method_cache|
        disk_file = disk_cached_file(file_path)

        ser_obj = Marshal.dump([file_path, method_cache])

        disk_file.open("w+") {|file| file.write(ser_obj)}
      end
    end

    # Internal: Get the pathname to the cached file.
    #
    # file_path: is the path to a file in the repository.
    #
    # Returns the pathname to the cached file.
    def disk_cached_file(file_path)
      @disk_cache.join(Digest::MD5.hexdigest(file_path))
    end

    # Internal: Deserialize the cached score from a cached file.
    #
    # file_path: is the path to a file in the repository.
    #
    # Returns the array deserialized.
    def load_cache(disk_file)
      new_obj = Marshal.load(disk_file.read)
      @cache[new_obj[0]] = new_obj[1]
      new_obj
    end

    # Public: Tells where the cache is stored.
    #
    # Returns the path to the cache.
    def location
      return @location if @location

      @location = ENV["MCCLIMATE_CACHE"]

      if @location
        @location = Pathname(@location)
      else
        @location = Pathname(Dir.tmpdir).join("mcclimate-cache")
      end
    end
  end

  # SynchronizedCache is an specialization from cache that synchronizes writes in the cache.
  # This cache is used by the AsyncRepositoryWalker to avoid overriding the file cache.
  class SynchronizedCache < Cache

    def initialize
      super

      @semaphore = Mutex.new
    end

    def put(file_path, method_name, score)
      @semaphore.synchronize { super }
    end
  end
end
