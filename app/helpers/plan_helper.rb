module PlanHelper
  def formatted_plan_interval(plan)
    if plan.interval_count > 1
      pluralize(plan.interval_count, plan.interval)
    else
      plan.interval
    end
  end
end
