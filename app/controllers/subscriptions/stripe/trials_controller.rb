class Subscriptions::Stripe::TrialsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_plan

  def show
    current_account.set_payment_processor :stripe

    # Mark setup intent payment method as default
    pay_payment_method = Pay::Stripe::PaymentMethod.sync_setup_intent(params[:setup_intent])
    pay_payment_method.make_default!

    @pay_subscription = current_account.payment_processor.subscribe(
      plan: @plan.id_for_processor(:stripe),
      trial_period_days: @plan.trial_period_days,
      automatic_tax: {
        enabled: @plan.taxed?
      },
      promotion_code: params[:promo_code]
    )
    redirect_to root_path, notice: t("subscriptions.created")
  end

  private

  def set_plan
    @plan = Plan.without_free.find_by_prefix_id!(params[:plan])
  rescue ActiveRecord::RecordNotFound
    redirect_to subscriptions_path
  end
end
