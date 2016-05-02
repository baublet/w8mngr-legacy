class PTFoodEntryLastEntryTest < ActiveSupport::TestCase

  test "should be no message" do
    last_entry_date = DateTime.now
    bug_me_hours = 24
    messages = PersonalTrainer::FoodEntries::last_entry(last_entry_date, bug_me_hours)
    assert_equal 0, messages.count
    assert_equal [], messages
  end

  test "should be 1 day" do
    last_entry_date = DateTime.now - 36.hours
    bug_me_hours = 24
    messages = PersonalTrainer::FoodEntries::last_entry(last_entry_date, bug_me_hours)
    assert_equal 1, messages.count
    assert_equal "You have not entered any foods into your food log in 1 day.", messages[0][:message]
  end

  test "should be 2 days" do
    last_entry_date = DateTime.now - 48.hours
    bug_me_hours = 24
    messages = PersonalTrainer::FoodEntries::last_entry(last_entry_date, bug_me_hours)
    assert_equal 1, messages.count
    assert_equal "You have not entered any foods into your food log in 2 days.", messages[0][:message]
  end

  test "should be 12 hours" do
    last_entry_date = DateTime.now - 12.hours
    bug_me_hours = 12
    messages = PersonalTrainer::FoodEntries::last_entry(last_entry_date, bug_me_hours)
    assert_equal 1, messages.count
    assert_equal "You have not entered any foods into your food log in about 12 hours.", messages[0][:message]
  end

end