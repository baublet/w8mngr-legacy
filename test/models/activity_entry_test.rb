require 'test_helper'

class ActivityEntryTest < ActiveSupport::TestCase

  test "activity entries should be valid" do
    activity = User.first.activity_entries.new
    activity.activity_id = Activity.first.id
    activity.day = 20010101
    activity.work = 100
    assert activity.valid?
  end

  test "activity entries should be invalid" do
    activity = ActivityEntry.new()
    assert_not activity.valid?

    activity.user_id = User.first.id
    assert_not activity.valid?

    activity.activity_id = Activity.first.id
    assert_not activity.valid?

    activity.day = 20010101
    assert_not activity.valid?

    activity.work = 1
    assert activity.valid?

  end

end
