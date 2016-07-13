require 'test_helper'

class ActivityTest < ActiveSupport::TestCase

  test "activity should be valid" do
    activity = User.first.activities.new({
      name: "aaaa",
      description: ""
    })
    assert activity.valid?
    (5..96).each do |i|
      activity.name = "a" * i
      assert activity.valid?
    end
  end

  test "activity should be invalid" do
    activity = Activity.new({
      name: "aaaa"
    })
    assert_not activity.valid?
    activity = User.first.activities.new({
      name: "",
      description: ""
    })
    assert_not activity.valid?
    (1..3).each do |i|
      activity.name = "a" * i
      assert_not activity.valid?
    end
  end

  test "muscle_groups_like should return proper values" do
    Activity::MUSCLE_GROUP_VALUES.each_with_index do |name, key|
      string = Activity::muscle_groups_like(Hash[name, 1])
      assert_equal "1", string[key], "In string: " + string + " (looking at index " + key.to_s + ")"
    end
  end

end
