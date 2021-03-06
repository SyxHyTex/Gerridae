$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'rspec'
require 'gerridae'

RSpec.configure do |config|

  config.color = true
  config.order = 'random'

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
