module InboundWebhooks
  class ApplicationController < ActionController::API
    private

    def payload
      @payload ||= request.body.read
    end
  end
end
