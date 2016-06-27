require 'test_helper'
require 'capybara/rails'
require 'headless'

class FoodEntriesJSTest < ActionDispatch::IntegrationTest
  # Make the Capybara DSL available in all integration tests
  include Capybara::DSL

  def setup
    @headless = Headless.new(reuse: true)
    @headless.start
    Capybara.javascript_driver = :webkit_with_qt_plugin_messages_suppressed
    Capybara.current_driver = Capybara.javascript_driver
    Capybara.exact = true
  end

  test "foodlog initializes properly" do
    log_in
    visit foodlog_path
    assert_equal foodlog_path, current_path
    assert_no_selector ("body.nojs")
  end

  test "user can add entry to food log" do
    log_in
    add_food
  end

  test "user can delete entry from food log" do
    log_in
    add_food
    original = FoodEntry.count
    original_shown = find_all(".app-form .row.entry").count
    first(".delete-btn").click
    5.times do
      sleep 1
      break unless original == FoodEntry.count
    end
    assert_not_equal original, FoodEntry.count
    # Makes sure that the item actually disappears from the dom
    assert_not_equal original_shown, find_all(".app-form .row.entry").count
  end

  # Reset sessions and driver between tests
  # Use super wherever this method is redefined in your individual test classes
  def teardown
    Capybara.reset_sessions!
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

  def add_food
    visit foodlog_path
    assert_equal foodlog_path, current_path
    within(".app-form.new") do
      original = FoodEntry.count
      fill_in "Description", with: "Test Item"
      click_button "New Entry"
      # Why does this test only work reliably when we click this twice? o_O
      click_button "New Entry"
      # We check this 15 times after 1 second of waiting since we have to
      # wait for the browser to send the information, the mocked server to
      # receive it, and then for the FoodEntry count to be updated. It takes
      # around 3 seconds...
      5.times do
        sleep 1
        break unless original == FoodEntry.count
      end
      assert_not_equal original, FoodEntry.count
    end
    # Make sure the new item shows
    # We have a minimum here of 1 because there are going to be a bunch of these
    # because each test here adds one...
    assert_selector ".app-form .row.entry", minimum: 1
  end
end