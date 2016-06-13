require 'test_helper'

class WeightEntryTest < ActiveSupport::TestCase
    def setup
        @user = User.new(email: "user@example.com", password: "foobar", password_confirmation:"foobar")
        # This is require for us to work with any food entries since they belong to valid users
        @user.save

        @weight = @user.weightentries.build(value: 83914, day: 19850502)
    end

    test "weight entry food data should be valid" do
        @wed = WeightEntryData.new()
        assert_not @wed.valid?
        @wed.user_id = @user.id
        assert_not @wed.valid?
        @wed.num = 1
        assert_not @wed.valid?
        @wed.length_scope = 'test'
        assert_not @wed.valid?
        @wed.length_scope = 'day'
        assert @wed.valid?
        @wed.length_scope = 'week'
        assert @wed.valid?
        @wed.length_scope = 'month'
        assert @wed.valid?
        @wed.length_scope = 'year'
        assert @wed.valid?
        @wed.length_scope = 'yurt'
        assert_not @wed.valid?
    end

    test "should initialize properly" do
        @wed = WeightEntryData.new(user_id: @user.id, num: 1, length_scope: 'day')
        assert @wed.valid?
    end

    # This generates 5 tests per macro per length scope
    test "should return proper data type" do
        @wed = FoodEntryData.new(user_id: @user.id, num: 1, length_scope: 'week')
        assert @wed.valid?
        ["day", "week", "month", "year"].each do |scope|
            @wed.length_scope = scope
            5.times do
                num = generate_int 1, 10
                num = num * (scope == 'day' ? 7 : 1)
                @wed.num = num
                data = @wed.time_data
                # puts "Worked: " + num.to_s + "; " + data.length.to_s + " (" + scope + ")"
                # We vary it by day because if we're mid-week, mid-month, etc., it builds the
                # array out of incomplete data
                assert_equal num,
                           data.length - (scope == 'day' ? 0 : 1),
                           "Failed on " + macro + "\nScope: " + scope + "\nNum: " + num.to_s + "\n" + data.to_yaml
            end
        end
    end
end
