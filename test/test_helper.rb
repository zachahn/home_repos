require File.expand_path("../../config/environment", __FILE__)
require "rails/test_help"

module ActiveSupport
  class TestCase
    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
  end
end

module ActionDispatch
  class IntegrationTest
    def login_as(user)
      manual_login_with(user.email, user.password)
    end

    def token_login_as(user, access_token)
      manual_login_with(user.email, access_token.password)
    end

    def manual_login_with(email, password)
      login_params = { email: email, password: password }
      post(session_url, params: { login: login_params })
    end
  end
end
