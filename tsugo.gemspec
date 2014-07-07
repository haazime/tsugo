# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tsugo/version'

Gem::Specification.new do |spec|
  spec.name          = "tsugo"
  spec.version       = Tsugo::VERSION
  spec.authors       = ["haazime"]
  spec.email         = ["h4zime@gmail.com"]
  spec.summary       = %q{Merge helper for Array of Hashes.}
  spec.description   = %q{Tsugo helps merge Array of Hashes with outer join.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
end
