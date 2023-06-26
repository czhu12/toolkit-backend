require "test_helper"

class TurboNativeTest < ActionDispatch::IntegrationTest
  test "unauthenticated request redirects to login" do
    get "/account/password"
    assert_redirected_to new_user_session_path
  end

  test "unauthenticated turbo native requests return 401" do
    get "/account/password", headers: {HTTP_USER_AGENT: "Turbo Native iOS"}
    assert_response :unauthorized
  end
end
