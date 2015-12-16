# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'capistrano/scm/tar/version'

Gem::Specification.new do |spec|
  spec.name          = "capistrano-scm-tar"
  spec.version       = Capistrano::Scm::Tar::VERSION
  spec.authors       = ["ziguzagu"]
  spec.email         = ["ziguzagu@gmail.com"]
  spec.summary       = %q{A tar strategy for Capistrano 3 to deploy tarball.}
  spec.description   = %q{A tar strategy for Capistrano 3 to deploy tarball.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "capistrano", "~> 3.0"

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", "~> 10.0"
end
