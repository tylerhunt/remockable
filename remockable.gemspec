Gem::Specification.new do |gem|
  gem.name    = 'remockable'
  gem.version = '0.0.1'
  gem.summary = 'An API-compatible rewrite of Remarkable.'
  gem.homepage = %q{http://github.com/tylerhunt/remockable}
  gem.authors = ['Tyler Hunt']

  gem.files = Dir['LICENSE', 'lib/**/*']

  gem.add_dependency 'activemodel', '~> 3.0.1'
  gem.add_dependency 'rspec-core', '~> 2.0.1'
  gem.add_dependency 'rspec-expectations', '~> 2.0.1'
end
