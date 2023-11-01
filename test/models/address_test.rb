# == Schema Information
#
# Table name: addresses
#
#  id               :bigint           not null, primary key
#  address_type     :integer
#  addressable_type :string           not null
#  city             :string
#  country          :string
#  line1            :string
#  line2            :string
#  postal_code      :string
#  state            :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  addressable_id   :bigint           not null
#
# Indexes
#
#  index_addresses_on_addressable  (addressable_type,addressable_id)
#
require "test_helper"

class AddressTest < ActiveSupport::TestCase
  setup do
    @user = users(:one)
    @address = addresses(:one)
    @address.addressable = @user
  end

  test "does not run update_pay_customer_addresses if no pay_customers" do
    @user.personal_account.set_payment_processor :fake_processor, allow_fake: true
    assert_no_changes -> { @user.personal_account.pay_customers } do
      @address.save!
    end
  end
end
