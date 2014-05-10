LIBRARY  = File.expand_path('../lib', __dir__)

$LOAD_PATH << LIBRARY  unless $LOAD_PATH.include?(LIBRARY)

require "benchmark"
require "mcclimate"

def bench(repo, sha = nil)
  Benchmark.bm do |x|
    x.report { McClimate::Complexity.new.run(repo, sha) }
  end
end

def bench_open_source(name, org = name)
  repo = File.expand_path(name, __dir__)

  if !File.directory?(repo)
    url = "https://github.com/#{org}/#{name}"

    puts "-> Cloning #{url}"
    # Rugged doesn't support clone via SSL yet, so we do it old school style.
    `git clone #{url} #{repo}`
  end

  bench(repo)
end
