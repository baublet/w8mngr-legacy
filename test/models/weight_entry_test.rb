require 'test_helper'

class WeightEntryTest < ActiveSupport::TestCase
    def setup
        @user = User.new(email: "user@example.com", password: "foobar", password_confirmation:"foobar")
        # This is require for us to work with any food entries since they belong to valid users
        @user.save

        @weight = @user.weightentries.build(value: 83914, day: 19850502)
    end

    test "weight should be valid" do
        assert @weight.valid?
    end

    test "weight should not be valid" do
        @weight.update_value "1 lbs"
        assert_not @weight.valid?
        @weight.update_value "3lbs"
        assert @weight.valid?
        @weight.update_value "2lbs"
        assert_not @weight.valid?
        @weight.update_value "1500lbs"
        assert @weight.valid?
        @weight.update_value "1501lbs"
        assert_not @weight.valid?
    end

    test "user can add weight to day" do
        assert @weight.save
        assert @user.weightentries.size, 1
    end

    test "user can delete weight from day" do
        assert @weight.save
        @user.reload
        assert @user.weightentries.first.destroy
        assert @user.weightentries.size, 0
    end

    test "happy path generative tests" do
        # Test 1,000 random values between 1,360 and 680,390
        for i in 1...1000 do
            @weight.value = generate_int 1360, 680390
            assert @weight.valid?, "Generative weight testing failed at " + @weight.value.to_s
        end
    end
end
