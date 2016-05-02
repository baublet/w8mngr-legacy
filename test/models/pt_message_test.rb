class PtMessageTest < ActiveSupport::TestCase
  def setup
    @user = users(:test)
  end

  test "should save a message" do
    last_entry_date = DateTime.now - 36.hours
    bug_me_hours = 24
    messages = PersonalTrainer::FoodEntries::last_entry(last_entry_date, bug_me_hours)
    assert_equal 1, messages.count
    assert_difference("PtMessage.count") do
      @user.save_pt_messages messages
    end
  end

  test "should save message, get it, then have zero unseen messages" do
    last_entry_date = DateTime.now - 36.hours
    bug_me_hours = 24
    messages = PersonalTrainer::FoodEntries::last_entry(last_entry_date, bug_me_hours)
    assert_equal 1, messages.count
    type = messages[0][:type]
    assert_difference("PtMessage.count") do
      @user.save_pt_messages messages
    end

    messages = @user.get_pt_messages type
    assert_equal 1, messages.count, "Unable to get messages of type [" + type + "] out of storage..."

    messages = @user.get_pt_messages type
    assert_equal 0, messages.count
  end

  test "should save message, save it again, then only update item in db" do
    last_entry_date = DateTime.now - 36.hours
    bug_me_hours = 24
    messages = PersonalTrainer::FoodEntries::last_entry(last_entry_date, bug_me_hours)
    assert_equal 1, messages.count
    assert_difference("PtMessage.count") do
      @user.save_pt_messages messages
    end

    last_entry_date = DateTime.now - 48.hours
    messages = PersonalTrainer::FoodEntries::last_entry(last_entry_date, bug_me_hours)
    assert_equal 1, messages.count
    assert_no_difference("PtMessage.count") do
      @user.save_pt_messages messages
    end
  end

end
