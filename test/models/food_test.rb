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
    
    test "measurement amounts must be a certain length" do
        @measurement.amount = nil
        assert_not @measurement.valid?
        @measurement.amount = ""
        assert_not @measurement.valid?
        @measurement.amount = "a" * 11
        assert_not @measurement.valid?
    end
    
    test "measurement units must be a certain length" do
        @measurement.unit = nil
        assert_not @measurement.valid?
        @measurement.unit = ""
        assert_not @measurement.valid?
        @measurement.unit = " " * 6
        assert_not @measurement.valid?
    end
    
    test "measurement calories must be valid" do
        @measurement.calories = nil
        assert_not @measurement.valid?
        @measurement.calories = ""
        assert_not @measurement.valid?
        @measurement.calories = 0
        assert @measurement.valid?
        @measurement.calories = 99999
        assert @measurement.valid?
    end
    
    test "measurement fat must be valid" do
        @measurement.fat = nil
        assert_not @measurement.valid?
        @measurement.fat = ""
        assert_not @measurement.valid?
        @measurement.fat = 0
        assert @measurement.valid?
        @measurement.fat = 99999
        assert @measurement.valid?
    end
    
    test "measurement carbs must be valid" do
        @measurement.carbs = nil
        assert_not @measurement.valid?
        @measurement.carbs = ""
        assert_not @measurement.valid?
        @measurement.carbs = 0
        assert @measurement.valid?
        @measurement.carbs = 99999
        assert @measurement.valid?
    end
    
    test "measurement protein must be valid" do
        @measurement.protein = nil
        assert_not @measurement.valid?
        @measurement.protein = ""
        assert_not @measurement.valid?
        @measurement.protein = 0
        assert @measurement.valid?
        @measurement.protein = 99999
        assert @measurement.valid?
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
