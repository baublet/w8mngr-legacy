class PTFoodEntryCalorieTargetsTest < ActiveSupport::TestCase

  test "should be no message because not within ten percent" do
    target = 2000
    days = [{day: 20000101, calories: 2050}]
    messages = PersonalTrainer::FoodEntries::calorie_targets(days, target)
    assert_equal 0, messages.count
    assert_equal [], messages

    days = [{day: 20000101, calories: 1950}]
    messages = PersonalTrainer::FoodEntries::calorie_targets(days, target)
    assert_equal 0, messages.count
    assert_equal [], messages
  end

  test "should be a message about being under" do
    target = 2000
    days = [
      {day: 20000101, calories: 1800},
      {day: 20000102, calories: 1800},
      {day: 20000103, calories: 1800},
      ]
    messages = PersonalTrainer::FoodEntries::calorie_targets(days, target)
    assert_equal 1, messages.count
    assert_equal 1, messages[0][:mood]
  end

  test "should be a message about being over" do
    target = 2000
    days = [
      {day: 20000101, calories: 2200},
      {day: 20000102, calories: 2400},
      {day: 20000103, calories: 2300},
    ]
    messages = PersonalTrainer::FoodEntries::calorie_targets(days, target)
    assert_equal 1, messages.count
    assert_equal 2, messages[0][:mood]
  end

end