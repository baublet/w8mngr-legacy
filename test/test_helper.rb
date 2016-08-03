# For approximating test coverage
require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  include SessionsHelper
  include ApplicationHelper

  def current_day
    Time.current.strftime('%Y%m%d')
  end

  # A custom method for testing if text appears in the response
  #
  # Use:
  #   assert response_contains "foo"
  def response_contains? string
    response.body.include? string.to_s
  end

  # A method for wrapping response_contains as a custom assertion with a message,
  # so that I don't have to write my own messages
  #
  # Use:
  #  assert_response_contains "foo"
  def assert_response_contains item
    if item.is_a?(Hash) || item.is_a?(Array)
      item.each_pair do |key, value|
        assert_response_contains value
      end
    else
      assert response_contains?(item), "Response did not contain: " + item.to_s
    end
  end

  # Simple login
  def log_in
    @user = users(:test)
    log_in_as(@user)
    assert logged_in?
  end

  # Logs in a test user
  def log_in_as(user, options = {})
      password      = options[:password]    || 'password'
      #remember_me   = options[:remember_me] || 1
      if integration_test?
          post login_path, session: {email: user.email, password: password}
      else
          session[:user_id] = user.id
      end
  end

  def integration_test?
      defined?(post_via_redirect)
  end

  # Generates a random number for testing
  def generate_int start_num = 0, end_num = 3000000
      rand(start_num...end_num)
  end

  # If there are javascript errors, this script raises an error
  def js_errors?
    errors = page.driver.error_messages
    return false unless errors.length > 0
    message = "\n-----------\nJS ERRORS\n-----------\n\n"
    errors.each do |msg|
      message += msg[:source] + ": (" + msg[:line_number].to_s + ")  " + msg[:message] + "\n"
    end
    raise Exception.new(message)
  end

  # We need this because the webkit driver doesn't reliably click things unless
  # we do it twice... Moreover, it only works if we page.find() for the element
  # twice.
  #
  # Params:
  # +element+: a css selector to search for using page.find(selector)
  #
  def click element
    page.find(element).click
    page.find(element).click
  end
end


# Custom output class to silence Qt warnings
# NOTE: This may cause issuse in the future so look here first if js
# tests fail
#
# Solution by jdguzman https://github.com/thoughtbot/capybara-webkit/issues/157#issuecomment-41619107
# and Sporky023        https://github.com/thoughtbot/capybara-webkit/issues/157#issuecomment-115847034
#
# With my own modifications for removing the messages I frequently receive.
#

class WebkitStderrWithQtPluginMessagesSuppressed
  IGNOREABLE = Regexp.new( [
    'CoreText performance',
    'userSpaceScaleFactor',
    'Internet Plug-Ins',
    'is implemented in bo',
    'will require at least version',
    'Fontconfig'
  ].join('|') )

  def write(message)
    if message =~ IGNOREABLE
      0
    else
      puts(message)
      1
    end
  end
end

Capybara.register_driver :webkit_with_qt_plugin_messages_suppressed do |app|
  Capybara::Webkit::Driver.new(
    app,
    Capybara::Webkit::Configuration.to_hash.merge(  # <------ maintain configuration set in Capybara::Webkit.configure block
      stderr: WebkitStderrWithQtPluginMessagesSuppressed.new
    )
  )
end

# To use:
# Capybara.javascript_driver = :webkit_with_qt_plugin_messages_suppressed