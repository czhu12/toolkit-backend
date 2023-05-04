class CreateInboundWebhooks < ActiveRecord::Migration[7.0]
  def change
    create_table :inbound_webhooks do |t|
      t.integer :status, default: 0, null: false
      t.text :body

      t.timestamps
    end
  end
end
