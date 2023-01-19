require "test_helper"

class Users::ConnectedAccountsTest < ActionDispatch::IntegrationTest
  setup do
    @connected_account = connected_accounts(:one)
    sign_in @connected_account.owner
  end

  test "connected accounts page" do
    get user_connected_accounts_path
    assert_response :success
  end

  test "destroy connected account" do
    assert_difference "ConnectedAccount.count", -1 do
      delete user_connected_account_path(@connected_account)
    end
    assert_redirected_to user_connected_accounts_path
  end
end
