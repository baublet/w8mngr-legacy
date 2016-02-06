require 'test_helper'

class PasswordResetTest < ActionDispatch::IntegrationTest
    def setup
        ActionMailer::Base.deliveries.clear
        @user = users(:test)
    end

    test "password resets" do
        get new_password_reset_path
        assert_template 'password_resets/new'

        # Invalid email address
        post password_resets_path, password_reset: { email: '' }
        assert_not flash.empty?
        assert_template 'password_resets/new'

        # Valid email!
        post password_resets_path, password_reset: { email: @user.email }

        # Not sure what this does
        assert_not_equal @user.reset_digest, @user.reload.reset_digest

        # Did it queue an email to send?
        assert_equal 1, ActionMailer::Base.deliveries.size
        assert_not flash.empty?
        assert_redirected_to root_url

        # Now, we're on the password reset form
        user = assigns(:user)

        # Test for entering the wrong email (basically, an exploit attempt)
        get edit_password_reset_path(user.reset_token, email: '')
        assert_redirected_to root_url

        # Test for the right email, wrong token
        get edit_password_reset_path('wrong token, obviously!', email: user.email)
        assert_redirected_to root_url

        # Right email, right token, can change!
        get edit_password_reset_path(user.reset_token, email: user.email)
        assert_template 'password_resets/edit'
        # And just to make sure our forms are built properly
        assert_select 'input[name=email][type=hidden][value=?]', user.email

        # Mismatched password and confirmation
        patch password_reset_path(user.reset_token),
                email: user.email,
                user: { password:               '123456',
                        password_confirmation:  '654321' }
        assert_select '.error-explanation'

        # Valid password and confirmation
        patch password_reset_path(user.reset_token),
                email: user.email,
                user: { password:               '123456',
                        password_confirmation:  '123456' }
        assert logged_in?
        assert_not flash.empty?
        assert_redirected_to user
    end

    test "expired password reset token" do
        get new_password_reset_path
        post password_resets_path, password_reset: {email: @user.email}

        @user = assigns(:user)
        @user.update_attribute(:reset_sent_at, 3.hours.ago)
        patch password_reset_path(@user.reset_token),
                email: @user.email,
                user: { password:               '123456',
                        password_confirmation:  '123456'}
        assert_response :redirect
        follow_redirect!
        assert_select '.alert.error'
    end
end
