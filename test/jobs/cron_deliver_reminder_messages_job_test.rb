require 'test_helper'

class CronDeliverReminderMessagesJobTest < ActiveJob::TestCase

  test "should queue properly" do
    assert_enqueued_with(job: CronDeliverReminderMessagesJob) do
      CronDeliverReminderMessagesJob.perform_later
    end
  end

  test "should remove a reminder message from the stack" do
    @user = users(:test)
    CronGenerateReminderMessagesJob.perform_now @user.id
    assert_difference '@user.pt_messages.where(seen: false).count', -1 do
      CronDeliverReminderMessagesJob.perform_now
      @user.reload
    end
  end

  test "should queue up appropriate jobs" do
    @user = users(:test)
    CronGenerateReminderMessagesJob.perform_now @user.id
    assert_enqueued_with(job: SendPtMessageJob) do
      CronDeliverReminderMessagesJob.perform_now
    end
  end

end