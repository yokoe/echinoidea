# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'echinoidea/version'

Gem::Specification.new do |gem|
  gem.name          = "echinoidea"
  gem.version       = Echinoidea::VERSION
  gem.authors       = ["Sota Yokoe"]
  gem.email         = ["gem@kreuz45.com"]
  gem.description   = "echinoidea is a command line unity project build helper."
  gem.summary       = "A command line unity project build helper"
  gem.homepage      = "https://github.com/yokoe/echinoidea"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = "echinoidea"
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
