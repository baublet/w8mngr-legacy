require 'test_helper'

class WelcomeControllerTest < ActionController::TestCase

  test "should get pages" do
    [:index, :privacy_policy, :terms_of_service,
      :getting_started, :contact_form, :beta].each do |page|
        test_page page
      end
  end

  private

  def test_page page
    get page
    assert_response :success
    assert_template page
  end

end
