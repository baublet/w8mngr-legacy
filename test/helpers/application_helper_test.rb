require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase

  test "full_title should be correct" do
    title = full_title
    assert_not_empty title
    assert title.is_a?(String)
    title = full_title "this goes in the full title"
    assert_not_empty title
    assert title.is_a?(String)
    assert title.include?("this goes in the full title")
  end

  test "current_day should be correct" do
    today = current_day
    assert_not_empty today
    assert today.is_a?(String)
    assert today.to_i > 19850101 && today.to_i < 20850101
  end

  test "convert_day_to_date should be correct" do
    date = convert_day_to_date "20010101"
    assert date.is_a?(Date)
    assert_equal date, Date.new(2001, 1, 1)
  end

  test "day_before day should be correct" do
    yesterday = day_before "20010102"
    assert yesterday.is_a?(String)
    assert_equal convert_day_to_date(yesterday), Date.new(2001, 1, 1)
  end

  test "day_after day should be correct" do
    tomorrow = day_after "20010101"
    assert tomorrow.is_a?(String)
    assert_equal convert_day_to_date(tomorrow), Date.new(2001, 1, 2)
  end

  test "previous_day should be correct" do
    cur_day = current_day
    prev_day = previous_day
    assert_not_empty prev_day
    assert prev_day.is_a?(String)
    assert prev_day.to_i > 19850101 && prev_day.to_i < 20850101
    assert prev_day.to_i < cur_day.to_i
  end

  test "next_day should be correct" do
    cur_day = current_day
    nxt_day = next_day
    assert_not_empty nxt_day
    assert nxt_day.is_a?(String)
    assert nxt_day.to_i > 19850101 && nxt_day.to_i < 20850101
    assert nxt_day.to_i > cur_day.to_i
  end

  test "nice_day should be correct" do
    nd = nice_day "20010101"
    assert nd.is_a?(String)
    assert_equal "Monday, January  1, 2001", nd
  end

  test "valid_day validates correctly" do
    passed = "20010101"
    validated = validate_day passed
    assert validated.is_a?(String)
    assert passed, validated
    # Now pass it one above our range
    passed = "30000101"
    validated = validate_day passed
    assert_not_equal passed, validated
    # And one below our range
    passed = "10000101"
    validated = validate_day passed
    assert_not_equal passed, validated
    # And now send a valid int,which should be converted properly
    passed = 20010101
    validated = validate_day passed
    assert_equal "20010101", validated
  end

end
