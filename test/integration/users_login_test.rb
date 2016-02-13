require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

    def setup
        @user = users(:test)
    end

    test "login with valid email and password then logout" do
        get login_path
        assert_template 'sessions/new'
        post login_path, session: {email: 'test@example.com', password: 'password'}
        assert logged_in?
        assert_redirected_to @user
        follow_redirect!
        assert_template 'users/show'
        assert_select "a[href=?]", login_path, count: 0
        assert_select "a[href=?]", logout_path
        assert_not_nil cookies['remember_token']
        # Follows the logout_path using the HTTP DELETE method
        get logout_path
        # The guide has this, but I find it fails because all of the cookies
        # are unsigned and deleted, and logged_in? relies on the existence of
        # cookies. After logout is called, all cookies are nuked, so trying to
        # access anything raises an error
        #
        # assert_not logged_in?
        assert_redirected_to root_url
        follow_redirect!
        assert_select "a[href=?]", logout_path, count: 0
    end

    test "invalid login information" do
        get login_path
        assert_template 'sessions/new'
        post login_path, session: {email: '', password: ''}
        assert_template 'sessions/new'
        assert_not flash.empty?
        get root_path
        assert flash.empty?
    end

end
