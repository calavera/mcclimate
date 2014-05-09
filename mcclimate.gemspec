# encoding: utf-8

Gem::Specification.new do |spec|
  spec.name          = "mcclimate"
  spec.version       = "0.0.1"
  spec.authors       = ["David Calavera"]
  spec.email         = ["david.calavera@gmail.com"]
  spec.description   = %q{McClimate complexity calculator}
  spec.summary       = spec.description
  spec.homepage      = "https://github.com/calavera/mcclimate"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "ruby_parser", "~> 3.6.0"

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency 'minitest', '~> 5'
  spec.add_development_dependency "rake"
end
