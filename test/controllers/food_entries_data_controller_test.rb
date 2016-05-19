require 'test_helper'

class FoodEntriesDataControllerTest < ActionController::TestCase
  def setup
    @user = users(:test)
    log_in_as(@user)
    assert logged_in?
    assert @user.foodentries.build( day: Time.current.strftime('%Y%m%d').to_i,
                                    description: "Test item entry",
                                    calories: 2300,
                                    fat: 50,
                                    carbs: 100,
                                    protein: 75).save
  end

  test "should get macros" do
    ["calories", "fat", "carbs", "protein"].each do |macro|
      test_macro macro, 1, "days"
      test_macro macro, 10, "days"
      test_macro macro, 100, "days"

      test_macro macro, 1, "weeks"
      test_macro macro, 10, "weeks"
      test_macro macro, 100, "weeks"

      test_macro macro, 1, "months"
      test_macro macro, 10, "months"
      test_macro macro, 100, "months"

      test_macro macro, 1, "years"
      test_macro macro, 3, "years"
      test_macro macro, 6, "years"
    end
  end

  private

  def test_macro macro, num, length_scope
    get :index, format: :json, column: macro, num: num, length_scope: length_scope
    assert_response :success
  end

end