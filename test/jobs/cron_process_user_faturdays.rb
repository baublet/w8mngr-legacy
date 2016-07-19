require 'test_helper'

class CronProcessUserFaturdaysJobTest < ActiveJob::TestCase

  test "should queue properly" do
    assert_enqueued_with(job: CronProcessUserFaturdaysJob) do
      CronProcessUserFaturdaysJob.perform_later
    end
  end

  test "should add faturday to user log" do
    @user = users(:test)
    [:mo, :tu, :we, :th, :fri, :sa, :su].each do |day|
      @user.preferences["faturday_enabled"] = true
      @user.preferences["auto_faturdays"][day] = true
    end
    @user.preferences["faturday_calories"] = 2000
    @user.save

    assert_difference '@user.foodentries.count' do
      CronProcessUserFaturdaysJob.perform_now
      @user.reload
    end

  end

end