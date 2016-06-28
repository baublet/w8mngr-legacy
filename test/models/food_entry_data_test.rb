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

  test "should not be valid" do
    @fed = FoodEntryData.new()
    assert_not @fed.valid?
    @fed.user_id = @user.id
    assert_not @fed.valid?
    @fed.num = 1
    assert_not @fed.valid?
    @fed.length_scope = 'test'
    assert_not @fed.valid?
    @fed.length_scope = 'day'
    assert @fed.valid?
    @fed.length_scope = 'week'
    assert @fed.valid?
    @fed.length_scope = 'month'
    assert @fed.valid?
    @fed.length_scope = 'year'
    assert @fed.valid?
    @fed.length_scope = 'yurt'
    assert_not @fed.valid?
  end

  test "should initialize" do
    @fed = FoodEntryData.new(user_id: @user.id, num: 1, length_scope: 'week')
    assert @fed.valid?
  end

  # This generates 5 tests per macro per length scope
  test "should return proper data type" do
    @fed = FoodEntryData.new(user_id: @user.id, num: 1, length_scope: 'week')
    assert @fed.valid?
    ["day", "week", "month", "year"].each do |scope|
      @fed.length_scope = scope
      ["calories", "fat", "carbs", "protein"].each do |macro|
        5.times do
          num = generate_int 1, 10
          num = num * (scope == 'day' ? 7 : 1)
          @fed.num = num
          data = @fed.time_data(macro)
          # puts "Worked: " + num.to_s + "; " + data.length.to_s + " (" + scope + ")"
          # We vary it by day because if we're mid-week, mid-month, etc., it builds the
          # array out of incomplete data
          assert_equal num,
                       data.length,
                       "Failed on " + macro + "\nScope: " + scope + "\nNum: " + num.to_s
        end
      end
    end
  end
end