ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require "rspec/mocks/minitest_integration"
require "vcr"
Dir[Rails.root.join("test", "support", "shared_tests", "*.rb")].each { |file| require file }

VCR.configure do |config|
  config.cassette_library_dir = "test/support/cassettes"
  config.ignore_request { ENV["DISABLE_VCR"] }
  config.hook_into :webmock
  config.default_cassette_options = { record: :new_episodes }
  config.filter_sensitive_data("{stripe_secret_key}"){ ENV.fetch("STRIPE_SECRET_KEY") }
end

class ActiveSupport::TestCase
  include FactoryBot::Syntax::Methods

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  private

  def cassette_name(class_name, test_name)
    [class_name, test_name].map do |str|
      str.underscore.gsub(/[^A-Z]+/i, "_")
    end.join("/")
  end
end

class ActionDispatch::IntegrationTest
  include WorkableJsonAssertions::Assertions
end
