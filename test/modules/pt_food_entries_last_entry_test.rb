require 'date'

class PTFoodEntryLastEntryTest < ActiveSupport::TestCase

  test "should be no message" do
    last_entry_date = DateTime.now
    bug_me_hours = 24
    messages = PersonalTrainer::last_entry(last_entry_date, bug_me_hours)
    assert_equal [], messages
  end

end