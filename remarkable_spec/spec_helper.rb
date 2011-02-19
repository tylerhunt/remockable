require 'active_model'
require 'active_support/core_ext/hash/slice'
require 'active_support/core_ext/string/inflections'

$:.unshift(File.expand_path('../lib', File.dirname(__FILE__)))
require 'remockable'

# Requires supporting files with custom matchers and macros, etc.,
# in ./support/ and its subdirectories.
Dir[File.expand_path('../support/**/*.rb', __FILE__)].each do |file|
  require(file)
end
