require 'rubocop'
require 'byebug'
require 'rubocop/rspec/support'

if ENV['CI']
  require 'simplecov'
  SimpleCov.start
end

module SpecHelper
  ROOT = Pathname.new(__dir__).parent.freeze
end

spec_helper_glob = File.expand_path('{support,shared}/*.rb', __dir__)
Dir.glob(spec_helper_glob).map(&method(:require))

RSpec.configure do |config|
  config.order = :random

  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect # Disable `should`
  end

  config.mock_with :rspec do |mocks|
    mocks.syntax = :expect # Disable `should_receive` and `stub`
  end

  # Forbid RSpec from monkey patching any of our objects
  config.disable_monkey_patching!

  # We should address configuration warnings when we upgrade
  config.raise_errors_for_deprecations!

  # RSpec gives helpful warnings when you are doing something wrong.
  # We should take their advice!
  config.raise_on_warning = true

  config.include RuboCop::RSpec::ExpectOffense
end

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'rubocop-rails_ddd'
