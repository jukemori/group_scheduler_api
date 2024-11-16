require "test_helper"

class Api::V1::CalendarInvitationsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get api_v1_calendar_invitations_index_url
    assert_response :success
  end
end
