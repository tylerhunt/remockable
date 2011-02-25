Gem::Specification.new do |gem|
  gem.name = 'remockable'
  gem.version = '0.0.1'
  gem.summary = 'A collection of RSpec matchers to simplify your web app specs.'
  gem.homepage = %q{http://github.com/tylerhunt/remockable}
  gem.authors = ['Tyler Hunt']

  gem.files = Dir['README', 'LICENSE', 'lib/**/*']

  gem.add_dependency 'activemodel', '~> 3.0.0'
  gem.add_dependency 'activerecord', '~> 3.0.0'
  gem.add_dependency 'activesupport', '~> 3.0.0'
  gem.add_dependency 'rspec-core', '~> 2.0'
  gem.add_dependency 'rspec-expectations', '~> 2.0'
  gem.add_development_dependency 'rspec-mocks', '~> 2.0'
  gem.add_development_dependency 'sqlite3', '~> 1.3.3'
end
