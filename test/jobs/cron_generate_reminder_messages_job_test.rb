require 'test_helper'

class CronGenerateReminderMessagesJobTest < ActiveJob::TestCase

  test "should queue properly" do
    assert_enqueued_with(job: CronGenerateReminderMessagesJob) do
      CronGenerateReminderMessagesJob.perform_later
    end
  end

  test "should generate reminder messages properly" do
    @user = users(:test)
    assert_difference '@user.pt_messages.count' do
      CronGenerateReminderMessagesJob.perform_now @user.id
      @user.reload
    end
  end

end
