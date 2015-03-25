# encoding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'active_triples/elasticsearch/version'

Gem::Specification.new do |spec|
  spec.name          = 'active_triples-elasticsearch'
  spec.version       = ActiveTriples::Elasticsearch::VERSION
  spec.platform      = Gem::Platform::RUBY
  spec.authors       = 'MJ Suhonos'
  spec.email         = 'mj@suhonos.ca'
  spec.summary       = 'Elasticsearch indexer for ActiveTriples models'
  spec.description   = 'TODO'
  spec.homepage      = 'https://github.com/ladder/active_triples-elasticsearch'
  spec.license       = 'APACHE2'
  spec.required_ruby_version = '>= 1.9.3'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(/^bin/) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(/^(test|spec|features)/)
  spec.require_paths = ['lib']

  spec.add_dependency 'active-triples', '~> 0.6'
  spec.add_dependency 'activejob', '~> 4.2'
  spec.add_dependency 'elasticsearch-model', '~> 0.1'

  spec.add_development_dependency 'pry', '~> 0.10'
  spec.add_development_dependency 'rspec', '~> 3.2'
  spec.add_development_dependency 'rubocop', '~> 0.29'
  spec.add_development_dependency 'semver', '~> 1.0'
  spec.add_development_dependency 'simplecov', '~> 0.9'
  spec.add_development_dependency 'wirble', '~> 0.1'
  spec.add_development_dependency 'yard', '~> 0.8'

  spec.extra_rdoc_files = [
    "LICENSE",
    "README.md"
  ]
end
