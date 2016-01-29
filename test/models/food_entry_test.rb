require 'test_helper'

class FoodEntryTest < ActiveSupport::TestCase
    def setup
        @user = User.new(email: "user@example.com", password: "foobar", password_confirmation:"foobar")
        # This is require for us to work with any food entries since they belong to valid users
        @user.save

        @newfoodentry = @user.foodentries.build(day: 19850502,
                                description: "Food description",
                                calories: 250,
                                fat: 10,
                                carbs: 35,
                                protein: 10)
    end

    test "food entry should be valid" do
        assert @newfoodentry.valid?
    end

    test "food entry description should not be blank or too short" do
        @newfoodentry.description = " " * 6
        assert_not @newfoodentry.valid?
        @newfoodentry.description = nil
        assert_not @newfoodentry.valid?
        @newfoodentry.description = ""
        assert_not @newfoodentry.valid?
    end

    test "food entry description should not be too long" do
        @newfoodentry.description = "a" * 155
        assert @newfoodentry.valid?
        @newfoodentry.description = "a" * 156
        assert_not @newfoodentry.valid?
    end

    test "food entry calories should be greater than 0" do
        @newfoodentry.calories = 0
        assert_not @newfoodentry.valid?
        @newfoodentry.calories = -1
        assert_not @newfoodentry.valid?
        @newfoodentry.calories = -9999999999
        assert_not @newfoodentry.valid?
    end

    test "food entry day should be within a certain range" do
        @newfoodentry.day = 19850429
        assert_not @newfoodentry.valid?
        @newfoodentry.day = 0
        assert_not @newfoodentry.valid?
        @newfoodentry.day = -99999
        assert_not @newfoodentry.valid?
        @newfoodentry.day = 19850435
        assert_not @newfoodentry.valid?
        @newfoodentry.day = 20850502
        assert_not @newfoodentry.valid?
        @newfoodentry.day = 99999999
        assert_not @newfoodentry.valid?
        @newfoodentry.day = 20000101
        assert @newfoodentry.valid?
    end
end
