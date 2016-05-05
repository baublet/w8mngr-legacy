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
        duplicate_user.email = @user.email.upcase
        @user.save
        assert_not duplicate_user.valid?
    end

    test "email addresses should be saved lowercase" do
        mixed_case_email = "FoO@BaR.CoM"
        @user.email = mixed_case_email
        @user.save
        assert_equal mixed_case_email.downcase, @user.reload.email
    end

    test "password should be present (not blank)" do
        @user.password = @user.password_confirmation = " " * 6
        assert_not @user.valid?
    end

    test "password should be of a minimum length" do
        @user.password = @user.password_confirmation = "a" * 5
        assert_not @user.valid?
    end

    test "user preferences set the correct default values" do
        @user.save
        @user.reload
        defaults = @user.default_preferences
        assert defaults.size > 0, "Default preferences failed to load"
        assert @user.preferences.size > 0, "User did not have default preferences set"
        #puts "\n" + @user.preferences.inspect  + "\n"
        assert_equal defaults.size, @user.preferences.size, "User preferences did not match default preferences"
        defaults.each do |pref, default|
            assert_equal default.to_s, @user.preferences[pref.to_s].to_s, "Failed to set proper default for " + pref.to_s
        end
    end
end
