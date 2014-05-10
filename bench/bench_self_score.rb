require_relative "bench_helper"

mcclimate = File.expand_path("mcclimate", __dir__)
unless File.directory?(mcclimate)
  require "fileutils"

  FileUtils.mkdir_p mcclimate

  this_repo = Pathname(__dir__).join("..")
  this_repo.each_child do |child|
    FileUtils.cp_r child, mcclimate unless child.to_path =~ /bench$/
  end
end

bench(mcclimate)
