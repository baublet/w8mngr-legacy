require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

    def setup
        @user = users(:test)
    end

    test "user can see their options" do
        login
        assert_select "main form.edit_user #name"
    end

    test "user can edit their name" do
        login
        post user_path(@user), name: "Tester McTesterson"
        assert_template "users/edit"
        name = css_select(".edit_user #name")
        assert_equal "Tester McTesterson", name[0]["value"]
    end

    test "user can edit their height" do
        login
        post user_path(@user), height_display: "6feet"
        assert_template "users/edit"
        height = css_select(".edit_user #height_display")
        assert_equal "6feet", height[0]["value"]
        # We don't test the actual height we store here, since we do all that
        # on the model and in the model tests
    end

    test "user can edit their sex" do
        login
        ["m", "f", "na"].each do |sex|
            post user_path(@user), sex: sex
            assert_template "users/edit"
            sex_val = css_select(".edit_user #sex-" + sex)
            assert_equal "checked", sex_val[0]["checked"]
        end
    end

    test "user can edit their birthday" do
        login
        ["May 1, 1985", "1954", "5/1/85", "34 years ago"].each do |birthday|
            post user_path(@user), birthday: birthday
            assert_template "users/edit"
            bday = css_select(".edit_user #birthday")
            assert_equal birthday, bday[0]["value"]
        end
    end

    test "user can edit their units" do
        login
        ["i", "m"].each do |unit|
            post user_path(@user), units: unit
            assert_template "users/edit"
            selected_unit = css_select(".edit_user #units-" + unit)
            assert_equal "checked", selected_unit[0]["checked"]
        end
    end

    private

    def login
        get login_path
        assert_template 'sessions/new'
        post login_path, session: {email: 'test@example.com', password: 'password'}
        assert logged_in?
        assert_redirected_to @user
        follow_redirect!
        assert_template 'users/show'
        get edit_user_path @user
        assert_template "users/edit"
    end
end
