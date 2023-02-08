require "test_helper"

class PerSeatSubscriptionTest < ActiveSupport::TestCase
  setup do
    @account = accounts(:fake_processor)
    assert_equal 1, @account.account_users_count
    @account.payment_processor.subscribe(plan: "per_seat", quantity: @account.account_users_count)
  end

  test "per seat subscription increments quantity when a user is added to the account" do
    @account.account_users.create!(user: users(:one))
    assert_equal 2, @account.payment_processor.subscription.quantity
  end

  test "per seat subscription decrements quantity when a user is removed from the account" do
    @account.account_users.last.destroy
    assert_equal 0, @account.payment_processor.subscription.quantity
  end
end
