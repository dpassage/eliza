# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'eliza/version'

Gem::Specification.new do |spec|
  spec.name          = 'eliza'
  spec.version       = Eliza::VERSION
  spec.authors       = ['David Paschich']
  spec.email         = ['dpassage@balveda.com']
  spec.summary       = %q(Eliza, the automated psychologist.)
  spec.description   = %q(Ruby implementation of Eliza,
    the automated psychologist.)
  spec.homepage      = 'https://github.com/dpassage/eliza'
  spec.license       = 'Apache-2.0'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(/^bin\//) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(/^(test|spec|features)\//)
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'pry-remote'
  spec.add_development_dependency 'pry-nav'
end
