# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'unicode/line_break/version'

Gem::Specification.new do |spec|
  spec.name          = "unicode-line_break"
  spec.version       = Unicode::LineBreak::VERSION
  spec.authors       = ["aoitaku"]
  spec.email         = ["aoitaku@gmail.com"]
  spec.summary       = %q{Ruby Implementation of Unicode Line Breaking Argorithme.}
  spec.description   = %q{Ruby Implementation of Unicode Line Breaking Argorithme.}
  spec.homepage      = "https://github.com/aoitaku/unicode-line_break"
  spec.license       = "zlib/libpng"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.2"
end
