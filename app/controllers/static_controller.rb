class StaticController < ApplicationController
  def index
    result = Scripts::List.execute(filters: params)
    @pagy, @scripts = pagy(result.scripts)
    respond_to do |format|
      format.html
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          "search_results",
          partial: "static/search_results",
          locals: { scripts: @scripts }
        )
      end
    end
  end

  def about
  end

  def pricing
    redirect_to root_path, alert: t(".no_plans_html", link: helpers.link_to_if(current_user&.admin?, "Add a plan in the admin", admin_plans_path)) unless Plan.without_free.exists?

    plans = Plan.visible.sorted
    @monthly_plans = plans.select(&:monthly?)
    @yearly_plans = plans.select(&:yearly?)
  end

  def terms
    @agreement = Rails.application.config.agreements.find { _1.id == :terms_of_service }
  end

  def privacy
    @agreement = Rails.application.config.agreements.find { _1.id == :privacy_policy }
  end
end
