require 'test_helper'

class FoodsHelperTest < ActionView::TestCase
  test "increment_popularity increments foods and measurements" do
    food = Food.first
    meas = Measurement.first
    assert_difference ["food.popularity", "meas.popularity"] do
      increment_popularity food.id, meas.id
      food.reload
      meas.reload
    end
  end
end