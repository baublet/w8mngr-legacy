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
        @measurement.amount = " " * 6
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
    
    test "food should have a measurement" do
        
    end
end
