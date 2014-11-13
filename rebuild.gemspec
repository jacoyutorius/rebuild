# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rebuild/version'

Gem::Specification.new do |spec|
  spec.name          = "rebuild"
  spec.version       = Rebuild::VERSION
  spec.authors       = ["Yuto Ogi"]
  spec.email         = ["jacoyutorius@gmail.com"]
  spec.summary       = "rubygems for enjoy 'RebuildFM'"
  spec.description   = "rubygems for enjoy 'RebuildFM'"
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"

  spec.add_dependency "thor"
  spec.add_dependency "sqlite3"
  spec.add_dependency "activerecord"
  spec.add_dependency "nokogiri"
end
