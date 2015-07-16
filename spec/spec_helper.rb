$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'rspec'
require 'gerridae'

Rspec.configure do |config|

  config.expect_with :rpsec do |c|
    c.syntax = :should
  end
end
