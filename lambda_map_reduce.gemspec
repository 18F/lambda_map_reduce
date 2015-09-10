# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'lambda_map_reduce/version'

Gem::Specification.new do |s|
  s.name          = 'lambda_map_reduce'
  s.version       = LambdaMapReduce::VERSION
  s.authors       = ['Mike Bland']
  s.email         = ['michael.bland@gsa.gov']
  s.summary       = 'A MapReduce implementation for use with lambdas'
  s.description   = (
    'This is a full implementation of the MapReduce algorithm specifically ' \
    'for use with lambdas. It is useful for problems that are a natural fit ' \
    'for the MapReduce model (such as building cross-references) when the ' \
    'data set fits easily within memory.'
  )
  s.homepage      = 'https://github.com/18F/lambda_map_reduce'
  s.license       = 'CC0'

  s.files         = `git ls-files -z *.md bin lib`.split("\x0") + [
  ]
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }

  s.add_development_dependency 'go_script', '~> 0.1'
  s.add_development_dependency 'about_yml'
  s.add_development_dependency 'rake', '~> 10.4'
  s.add_development_dependency 'minitest'
  s.add_development_dependency 'codeclimate-test-reporter'
  s.add_development_dependency 'coveralls'
  s.add_development_dependency 'rubocop'
end
