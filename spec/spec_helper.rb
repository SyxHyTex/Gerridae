$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'rspec'
require 'gerridae'

RSpec.configure do |config|

  config.color = true
  config.order = 'random'
end
