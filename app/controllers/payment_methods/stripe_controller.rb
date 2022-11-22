class PaymentMethods::StripeController < ApplicationController
  before_action :authenticate_user!
  before_action :set_setup_intent

  def show
    if @setup_intent.status == "succeeded"
      payment_processor = current_account.set_payment_processor(:stripe)
      pay_payment_method = Pay::Stripe::PaymentMethod.sync(@setup_intent.payment_method)
      pay_payment_method.make_default!

      # if any past_due subscriptions exist, attempt to pay them
      payment_processor.retry_past_due_subscriptions!

      redirect_to subscriptions_path, notice: t("payment_methods.create.updated")
    else
      redirect_to new_payment_method_path, alert: t("something_went_wrong")
    end
  rescue Pay::ActionRequired => e
    redirect_to pay.payment_path(e.payment.id)
  rescue Pay::Error => e
    redirect_to new_payment_method_path, alert: t("something_went_wrong")
  end

  private

  def set_setup_intent
    @setup_intent = ::Stripe::SetupIntent.retrieve(params[:setup_intent])
  end
end
