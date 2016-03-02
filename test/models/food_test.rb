require 'test_helper'

class FoodTest < ActiveSupport::TestCase
    def setup
        @user = User.new(email: "user@example.com", password: "foobar", password_confirmation:"foobar")
        # This is require for us to work with any food entries since they belong to valid users
        @user.save

        @food = @user.foods.build(  name:        "Test Food",
                                    description: "Test description.")

        @measurement = @food.measurements.build(
                                    amount:   "1",
                                    unit:     "units",
                                    calories: 1,
                                    fat:      2,
                                    carbs:    3,
                                    protein:  4)
    end

    test "food should be valid" do
        assert @food.valid?
    end

    test "food name should not be too long or short" do
        @food.name = "a"
        assert_not @food.valid?
        @food.name = "a" * 156
        assert_not @food.valid?
    end

    test "food should have a measurement" do
        @food = @user.foods.build(  name:        "Test Food",
                                    description: "Test description.")
        assert_not @food.valid?
    end

    test "cannot delete last measurement of a food" do
        assert_not @measurement.destroy.nil?
    end
end
