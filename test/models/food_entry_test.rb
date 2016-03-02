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

    test "happy path generative tests" do
        # This is the general range for which users would enter calories.
        # I doubtanyone would ever enter anything with more than 30,000 calories
        for i in 0...30000 do
            @newfoodentry.calories = i
            assert @newfoodentry.valid?, "Generative test failed for calories at " + i.to_s
        end
        # The same here for macros. I've never heard of any food or recipe
        # calling for more than 10,000 of either fat, carbs or protein!
        for i in 0...10000 do
            @newfoodentry.fat = i
            @newfoodentry.carbs = i
            @newfoodentry.protein = i
            assert @newfoodentry.valid?, "Generative test failed for macros at " + i.to_s
        end
        # Now do 500 tests for totally random numbers
        for i in 0...500 do
            @newfoodentry.calories = generate_int
            assert @newfoodentry.valid?, "Generative test failed for calories at " + @newfoodentry.calories.to_s
            @newfoodentry.fat = generate_int
            assert @newfoodentry.valid?, "Generative test failed for fat at " + @newfoodentry.fat.to_s
            @newfoodentry.carbs = generate_int
            assert @newfoodentry.valid?, "Generative test failed for carbs at " + @newfoodentry.carbs.to_s
            @newfoodentry.protein = generate_int
            assert @newfoodentry.valid?, "Generative test failed for protein at " + @newfoodentry.protein.to_s
        end
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
        assert @newfoodentry.valid?
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
