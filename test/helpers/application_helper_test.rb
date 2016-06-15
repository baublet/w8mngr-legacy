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

end
