require 'test_helper'

class UserTest < ActiveSupport::TestCase
    def setup
        @user = User.new(email: "user@example.com", password: "foobar", password_confirmation: "foobar")
    end
end
