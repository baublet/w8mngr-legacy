require 'test_helper'

class UserTest < ActiveSupport::TestCase
    def setup
        @user = User.new(email: "user@example.com", password: "foobar", password_confirmation: "foobar")
    end

    test "should be valid" do
        assert @user.valid?
    end

    test "email should be present" do
        @user.email = " "
        assert_not @user.valid?
    end

    test "email should not be too long" do
        @user.email = "a" * 244 + "@example.com"
        assert_not @user.valid?
    end

    test "email should be a valid address" do
        valid_addresses = %w[user@example.com USER@food.COM A_US-er@food.bar.org FIRSt.last@food.jp alice+bob@baz.cn]
        valid_addresses.each do |valid_address|
            @user.email = valid_address
            assert @user.valid?, "#{valid_address.inspect} should be valid"
        end
    end

    test "email should not be invalid address" do
        invalid_addresses = %w[user@example,com user_at_food.org user.name@example. foo@bar_baz.com foo@bar+baz.com]
        invalid_addresses.each do |invalid_address|
            @user.email = invalid_address
            assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
        end
    end

    test "email addresses should be unique" do
        duplicate_user = @user.dup
        @user.save
        assert_not duplicate_user.valid?
    end
end
