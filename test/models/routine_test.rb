require 'test_helper'

class RoutineTest < ActiveSupport::TestCase

  test "should require user" do
    r = Routine.new
    assert_not r.valid?
    r.user_id = users(:test).id
    assert_not r.valid?
    r.name = "Test routine name"
    assert r.valid?
  end

  test "should have appropriate length name" do
    (1..3).each do |l|
      r = users(:test).routines.build(name: "a" * l)
      assert_not r.valid?
    end
    (4..96).each  do |l|
      r = users(:test).routines.build(name: "a" * l)
      assert r.valid?
    end
  end

  test "should take valid activities" do
    r = users(:test).routines.build(name: "aaaa")
    assert r.valid?
    # Note, if we pass anything other than integers into the activities array,
    # ActiveRecord automatically converts it to an integer
    r.activities = [activities(:one).id]
    assert r.valid?
  end

end
