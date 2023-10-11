require "test_helper"

class Jumpstart::AdminTest < ActionDispatch::IntegrationTest
  test "cannot access /admin logged out" do
    get "/admin"
    assert_response :not_found
  end

  test "cannot access /admin as regular user" do
    sign_in users(:one)
    get "/admin"
    assert_response :not_found
  end

  test "can access /admin as admin user" do
    sign_in users(:admin)
    get "/admin"
    assert_response :success
  end
end
