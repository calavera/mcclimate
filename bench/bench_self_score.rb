LIBRARY  = File.expand_path('../lib', __dir__)

$LOAD_PATH << LIBRARY  unless $LOAD_PATH.include?(LIBRARY)

THIS_REPO = File.expand_path('..', __dir__)

require "benchmark"
require "mcclimate"

Benchmark.bm do |x|
  x.report { McClimate::Complexity.new.run(THIS_REPO) }
end
