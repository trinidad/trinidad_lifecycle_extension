begin
  require 'trinidad'
rescue LoadError
  require 'rubygems'
  require 'trinidad'
end

require 'rspec'

RSpec.configure do |config|
  config.mock_with :mocha
end

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'trinidad_lifecycle_extension'
