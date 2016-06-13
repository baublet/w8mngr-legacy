require 'test_helper'

class WeightEntriesDataControllerTest < ActionController::TestCase

  test "should not work without login" do
    get :index, format: 'json', num: 1, length_scope: 'week'
    assert_response :redirect
    assert_redirected_to login_path
  end

  test "should not work in any format but json" do
    log_in
    begin
      get :index, num: 1, length_scope: 'week'
      # This should never be executed since the above will generate an error
      assert false
    rescue
      assert true
    end
  end

  test "should get data" do
    log_in
    get :index, format: 'json', num: 1, length_scope: 'week'
    assert_response :success
    body = JSON.parse(response.body)
    assert body.is_a?(Array)
  end

  test "should get data from many generated scopes" do
    log_in
    ["day", "month", "week", "year"].each do |scope|
      # Do 10 random numbers for each scope
      10.times do
        num = generate_int 1, 50
        get :index, format: 'json', num: num, length_scope: scope
        assert_response :success
        body = JSON.parse(response.body)
        assert body.is_a?(Array)
        assert_equal body.length, num
      end
    end
  end

end
