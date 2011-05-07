require 'active_model'
require 'active_record'

$:.unshift(File.expand_path('../lib', File.dirname(__FILE__)))
require 'remockable'

# Requires supporting files with custom matchers and macros, etc.,
# in ./support/ and its subdirectories.
Dir[File.expand_path('../support/**/*.rb', __FILE__)].each do |file|
  require(file)
end

RSpec.configure do |config|
  config.mock_with :rspec
  config.filter_run :focus => true
  config.run_all_when_everything_filtered = true
end
