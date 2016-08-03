require 'test_helper'

class WeightEntriesIntegrationTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:test)
    log_in_as(@user)
    assert logged_in?
  end

  test "user can create new weight" do
    create_valid_weight
  end

  test "user can delete weights" do
    create_valid_weight
    last_entry = WeightEntry.last
    assert_response_contains weight_entry_delete_path(last_entry)
    assert_difference "WeightEntry.count", -1 do
      get weight_entry_delete_path(last_entry)
    end
    assert_response :redirect
    follow_redirect!
    assert_template "weight_entries/index"
  end

  test "user can add two weights and it shows a correct average" do
    create_valid_weight "183lbs", 183
    assert_response_contains 183
    create_valid_weight "185lbs", 185
    assert_response_contains 185
    assert_response_contains 183

    assert_response_contains 184
  end

  private

  def create_valid_weight weight_text = "185lbs", weight_number = 185
    get weightlog_path
    assert_template "weight_entries/index"
    @weight_entry = {
        day: 20000101,
        value: weight_text
    }
    assert_difference "WeightEntry.count" do
    	post weight_entries_path, weight_entry: @weight_entry
    end
    assert_response :redirect
    follow_redirect!
    assert_response_contains weight_number
  end

end