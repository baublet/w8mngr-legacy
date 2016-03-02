require 'test_helper'

class MeasurementTest < ActiveSupport::TestCase
  # For how our measurements and foods integrate, see our foods tests
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

  test "happy path generative tests" do
      # This is the general range for which users would enter calories.
      # I doubtanyone would ever enter anything with more than 30,000 calories
      for i in 0...30000 do
          @measurement.calories = i
          assert @measurement.valid?, "Generative test failed for calories at " + i.to_s
      end
      # The same here for macros. I've never heard of any food or recipe
      # calling for more than 10,000 of either fat, carbs or protein!
      for i in 0...10000 do
          @measurement.fat = i
          @measurement.carbs = i
          @measurement.protein = i
          assert @measurement.valid?, "Generative test failed for macros at " + i.to_s
      end
      # Now do 500 tests for totally random numbers
      for i in 0...500 do
          @measurement.calories = generate_int
          assert @measurement.valid?, "Generative test failed for calories at " + @measurement.calories.to_s
          @measurement.fat = generate_int
          assert @measurement.valid?, "Generative test failed for fat at " + @measurement.fat.to_s
          @measurement.carbs = generate_int
          assert @measurement.valid?, "Generative test failed for carbs at " + @measurement.carbs.to_s
          @measurement.protein = generate_int
          assert @measurement.valid?, "Generative test failed for protein at " + @measurement.protein.to_s
      end
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
end
