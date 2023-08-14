ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "minitest/mock"
require "webmock/minitest"

# Uncomment to view full stack trace in tests
# Rails.backtrace_cleaner.remove_silencers!

require "sidekiq/testing" if defined?(Sidekiq)

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def json_response
    JSON.parse(response.body)
  end
end

class ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def switch_account(account)
    patch "/accounts/#{account.id}/switch"
  end
end

WebMock.disable_net_connect!({
  allow_localhost: true,
  allow: [
    "chromedriver.storage.googleapis.com",
    "api.stripe.com"
  ]
})
