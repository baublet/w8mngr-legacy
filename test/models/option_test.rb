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
        @user = User.find_by(email: "user@example.com")
        assert_equal "New value", @user.option["Test option"]
    end

    test "cannot save a user when they have an unknown specified option" do
        @user.option["Test Option"] = "Value"
        assert_not @user.save
        Option.new(name: "Test Option", kind: "t").save
        assert @user.save
        assert @user.save_options
    end

    test "numeric options" do
        option = Option.new(name: "height", kind:"n", default_value: "0")
        option.save
        @user.option["height"] = "72"
        assert @user.save
        @user = User.find_by(email: "user@example.com")
        assert_equal "72", @user.option["height"]
        @user.option["height"] = "not a number"
        assert_not @user.save
        assert_not @user.save_options
        @user.option["height"] = "12"
        assert @user.save_options
    end

    test "boolean options" do
        Option.new(name: "toggle", kind:"b", default_value: "false").save
        @user.option["toggle"] = "false"
        assert @user.save
        @user.option["toggle"] = "true"
        assert @user.save
        @user.option["toggle"] = "TrUe"
        assert @user.save
        @user.option["toggle"] = "FalSe"
        assert @user.save
        @user.option["toggle"] = "not boolean"
        assert_not @user.save
    end

    test "options with specific values" do
        options = " yellow :: Bumblebee
                    red :: Apple
                    blue :: Water
                    1 :: Number
                    7:: Coconuts"
        Option.new(name: "select", kind: "o", values: options, default_value: "red").save
        assert_equal "red", @user.option["select"]
        @user.option["select"] = "blue"
        assert @user.save
        assert_equal "blue", @user.option["select"]
        @user.option["select"] = "green"
        assert_not @user.save
        @user.option["select"] = "yellow"
        assert @user.save
    end
end
