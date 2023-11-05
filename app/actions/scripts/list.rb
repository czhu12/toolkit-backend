# frozen_string_literal: true

module Scripts
  class List
    extend LightService::Action
    PAGE_SIZE = 10

    expects :filters
    promises :scripts
    executed do |context|
      scripts = Script.public_visibility
      if context.filters[:q].present?
        scripts = scripts.search_for(context.filters[:q])
      end

      if context.filters[:owner_id].present?
        scripts = scripts.where(user_id: context.filters[:owner_id])
      end

      context.scripts = scripts.order(run_count: :desc)
    end
  end
end