class AddBillingEmailToAccounts < ActiveRecord::Migration[7.0]
  def change
    add_column :accounts, :billing_email, :string
  end
end
