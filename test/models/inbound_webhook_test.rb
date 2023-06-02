# == Schema Information
#
# Table name: inbound_webhooks
#
#  id         :bigint           not null, primary key
#  body       :text
#  status     :integer          default("pending"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require "test_helper"

class InboundWebhookTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper

  test "pending default status" do
    assert InboundWebhook.new.pending?
  end

  test "enqueus incineration when processed" do
    inbound_webhook = inbound_webhooks(:fake_service)
    assert_enqueued_with job: InboundWebhooks::IncinerationJob, args: [inbound_webhook] do
      inbound_webhook.processed!
    end
  end
end
