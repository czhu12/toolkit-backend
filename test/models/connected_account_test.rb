# == Schema Information
#
# Table name: connected_accounts
#
#  id                  :bigint           not null, primary key
#  access_token        :string
#  access_token_secret :string
#  auth                :text
#  expires_at          :datetime
#  owner_type          :string
#  provider            :string
#  refresh_token       :string
#  uid                 :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  owner_id            :bigint
#
# Indexes
#
#  index_connected_accounts_on_owner_id_and_owner_type  (owner_id,owner_type)
#

require "test_helper"

class ConnectedAccountTest < ActiveSupport::TestCase
  test "handles access token secrets" do
    ca = ConnectedAccount.new(access_token_secret: "test")
    assert_equal "test", ca.access_token_secret
  end

  test "handles empty access token secrets" do
    assert_nothing_raised do
      ConnectedAccount.new(access_token_secret: "")
    end
  end

  test "expired if token expired in the past" do
    ca = ConnectedAccount.new(expires_at: 1.hour.ago)
    assert ca.expired?
  end

  test "expiring if token expires soon" do
    ca = ConnectedAccount.new(expires_at: 4.minutes.from_now)
    assert ca.expired?
  end

  test "not expiring if token expires in the future" do
    ca = ConnectedAccount.new(expires_at: 1.day.from_now)
    assert_not ca.expired?
  end

  test "not expiring if token has no expiration" do
    ca = ConnectedAccount.new(expires_at: nil)
    assert_not ca.expired?
  end
end
