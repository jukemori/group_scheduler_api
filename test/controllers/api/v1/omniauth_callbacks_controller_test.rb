require "test_helper"

class Api::V1::OmniauthCallbacksControllerTest < ActionDispatch::IntegrationTest
  test "should get google_oauth2" do
    get api_v1_omniauth_callbacks_google_oauth2_url
    assert_response :success
  end

  test "should get failure" do
    get api_v1_omniauth_callbacks_failure_url
    assert_response :success
  end
end
