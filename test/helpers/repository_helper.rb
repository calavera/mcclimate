module Test
  module RepositoryHelper
    def create_simple_repo
      new_tmp_repo do |dir|
        FileUtils.touch("#{dir}/ruby.rb")
      end
    end

    def create_deep_repo
      new_tmp_repo do |dir|
        FileUtils.mkdir("#{dir}/foo")
        FileUtils.touch("#{dir}/foo/ruby.rb")
      end
    end

    def create_empty_git_repo
      new_tmp_repo do |dir|
        Rugged::Repository.init_at(dir)
      end
    end

    def new_tmp_repo
      dir = Dir.mktmpdir
      yield(dir) if block_given?

      Kernel.at_exit{ FileUtils.rm_rf(dir)}

      dir
    end
  end
end
