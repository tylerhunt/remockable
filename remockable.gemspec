require './lib/remockable/version'

Gem::Specification.new do |spec|
  spec.name = 'remockable'
  spec.version = Remockable::VERSION
  spec.authors = ['Tyler Hunt']
  spec.summary = 'A collection of RSpec matchers for web apps.'
  spec.homepage = 'http://github.com/tylerhunt/remockable'
  spec.license = 'MIT'

  spec.add_dependency 'activemodel', '~> 4.0'
  spec.add_dependency 'activerecord', '~> 4.0'
  spec.add_dependency 'activesupport', '~> 4.0'
  spec.add_dependency 'rspec-core', '~> 2.0'
  spec.add_dependency 'rspec-expectations', '~> 2.0'
  spec.add_dependency 'rspec-mocks', '~> 2.0'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'sqlite3', '~> 1.3.4'

  spec.files = `git ls-files`.split($/)
  spec.executables = spec.files.grep(%r{^bin/}) { |file| File.basename(file) }
  spec.test_files = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']
end
