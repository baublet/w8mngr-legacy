require 'test_helper'

class OptionTest < ActiveSupport::TestCase
    def setup
        @user = User.new(email: "user@example.com", password: "foobar", password_confirmation:"foobar")
        # This is require for us to work with any food entries since they belong to valid users
        @user.save
    end

    test "can create new option and manipulate it" do
        option = Option.new(name: "Test option", kind:"t", default_value: "Default")
        option.save
        @user.option["Test option"] = "New value"
        @user.save
        assert_equal "New value", @user.option["Test option"]
        @user2 = User.find_by(email: "user@example.com")
        assert_equal "New value", @user2.option["Test option"]
    end

    test "cannot save a user when they have an unknown specified option" do
        @user.option["Test Option"] = "Value"
        assert_not @user.save
        Option.new(name: "Test Option").save
        assert @user.save
    end
end
