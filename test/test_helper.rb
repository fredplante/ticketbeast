ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require "rspec/mocks/minitest_integration"
require "vcr"

VCR.configure do |config|
  config.cassette_library_dir = "support/cassettes"
  config.hook_into :webmock
end

class ActiveSupport::TestCase
  include FactoryBot::Syntax::Methods

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end

class ActionDispatch::IntegrationTest
  include WorkableJsonAssertions::Assertions
end
