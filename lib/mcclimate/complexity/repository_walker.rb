module McClimate
  # McClimate::RepositoryWalker iterates over the content inside
  # a directory to find the ruby files to analize.
  #
  # This search also walks inside nested directories.
  class RepositoryWalker

    # Public: Walk over the entries in the directory given.
    #
    # path: is the path to a directory in the file system.
    # block: is the action to perform when we find a ruby file.
    #
    # Returns nothing.
    def walk(path, &block)
      dir = Pathname(path)
      return unless dir.directory?

      dir.each_child do |path|
        walk(path, &block) if path.directory?

        block.call(path) if ruby_source?(path.to_s)
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
      path =~ /\.rb\Z/
    end
  end
end
