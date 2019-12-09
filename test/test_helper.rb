ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require "rspec/mocks/minitest_integration"
require "vcr"

VCR.configure do |config|
  config.cassette_library_dir = "support/cassettes"
  config.ignore_request { ENV["DISABLE_VCR"] }
  config.hook_into :webmock
  config.default_cassette_options = { record: :new_episodes }
end

class ActiveSupport::TestCase
  include FactoryBot::Syntax::Methods

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Monkey patch the `test` DSL to enable VCR and configure a cassette named
  # based on the test method. This means that a test written like this:
  #
  # class OrderTest < ActiveSupport::TestCase
  #   test "user can place order" do
  #     ...
  #   end
  # end
  #
  # will automatically use VCR to intercept and record/play back any external
  # HTTP requests using `cassettes/order_test/_user_can_place_order.yml`.
  def self.test(test_name, &block)
    return super if block.nil?

    cassette = [name, test_name].map do |str|
      str.underscore.gsub(/[^A-Z]+/i, "_")
    end.join("/")

    super(test_name) do
      VCR.use_cassette(cassette) do
        instance_eval(&block)
      end
    end
  end
end

class ActionDispatch::IntegrationTest
  include WorkableJsonAssertions::Assertions
end
