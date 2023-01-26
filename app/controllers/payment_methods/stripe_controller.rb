class PaymentMethods::StripeController < ApplicationController
  before_action :authenticate_user!
  before_action :set_setup_intent

  def show
    if @setup_intent.status == "succeeded"
      payment_processor = current_account.set_payment_processor(:stripe)
      pay_payment_method = Pay::Stripe::PaymentMethod.sync(@setup_intent.payment_method)
      pay_payment_method.make_default!

      # If any past_due subscriptions exist, attempt to pay them before they are marked unpaid or canceled
      payment_processor.subscriptions.past_due.each(&:retry_failed_payment)

      # If unpaid subscriptions exist, attempt to pay the open invoices to put the subscription in good standing again
      payment_processor.subscriptions.metered.unpaid.each(&:pay_open_invoices)

      # If the latest invoice for an unpaid subscription is more than $0, you will want to finalize and pay it to make the subscription active again

      redirect_to subscriptions_path, notice: t("payment_methods.create.updated")
    else
      redirect_to new_payment_method_path, alert: t("something_went_wrong")
    end
  rescue Pay::ActionRequired => e
    redirect_to pay.payment_path(e.payment.id)
  rescue Pay::Error => e
    redirect_to new_payment_method_path, alert: e.message
  end

  private

  def set_setup_intent
    @setup_intent = ::Stripe::SetupIntent.retrieve(params[:setup_intent])
  end
end
