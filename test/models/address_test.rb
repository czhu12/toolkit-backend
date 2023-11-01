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
    @address = Address.new(
      addressable: accounts(:one),
      address_type: "billing",
      line1: "1 Apple Way",
      city: "Cupertino",
      postal_code: 95014,
      country: "US"
    )
  end

  test "updates pay customer if billing address" do
    assert @address.billing?
    assert_raises StandardError do
      @address.stub :update_pay_customer_addresses, -> { raise StandardError } do
        @address.save!
      end
    end
  end

  test "does not update pay customer if shipping address" do
    @address.address_type = :shipping
    assert_nothing_raised do
      @address.stub :update_pay_customer_addresses, -> { raise StandardError } do
        @address.save!
      end
    end
  end

  test "does not update pay customer if addressable is not a pay object" do
    @address.addressable = users(:one)
    assert_nothing_raised do
      @address.stub :update_pay_customer_addresses, -> { raise StandardError } do
        @address.save!
      end
    end
  end
end
