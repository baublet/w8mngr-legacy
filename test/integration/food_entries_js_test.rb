require 'test_helper'
require 'capybara/rails'
require 'headless'

class FoodEntriesJSTest < ActionDispatch::IntegrationTest
  # Make the Capybara DSL available in all integration tests
  include Capybara::DSL

  def setup
    @headless = Headless.new
    @headless.start
    Capybara.javascript_driver = :webkit
    Capybara.current_driver = Capybara.javascript_driver
    Capybara.exact = true
  end

  test "foodlog initializes properly" do
    log_in
    visit foodlog_path
    assert_equal foodlog_path, current_path
    assert_no_selector ("body.nojs")
  end

  # Reset sessions and driver between tests
  # Use super wherever this method is redefined in your individual test classes
  def teardown
    Capybara.reset_sessions!
    Capybara.use_default_driver
    @headless.destroy
  end

  private

  def log_in
    @user = users(:test)
    visit login_path
    within("#main") do
      fill_in "Email", :with => @user.email
      fill_in "Password", :with => "password"
      click_link_or_button "Log in"
    end
    assert_equal dashboard_path, current_path
  end
end