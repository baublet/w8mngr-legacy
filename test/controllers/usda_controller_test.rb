require 'test_helper'

class UsdaControllerTest < ActionController::TestCase
  def setup
    @user = users(:test)
    log_in_as(@user)
    assert logged_in?
  end

  test "should get pull" do
    post :pull, ndbno: "01009"
    assert_response :redirect
  end

end