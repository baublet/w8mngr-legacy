require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

    test "invalid signup information" do
        get signup_path
        assert_no_difference 'User.count' do
            post users_path, user: { email: "user@invalid.com",
                                     password:              "foo",
                                     password_confirmation: "bar" }
        end
        assert_template 'users/new'
    end

    test "valid signup information" do
        get signup_path
        assert_difference 'User.count', 1 do
            post users_path, user: { email: "user@valid.com",
                                     password:              "foobar",
                                     password_confirmation: "foobar"}
        end
        # Because after signup, we log the user in, then redirect them to their profile
        follow_redirect!
        assert_template 'users/show'
        assert logged_in?
    end
end
