require "rails/generators/active_record/migration"

class InboundWebhookGenerator < Rails::Generators::NamedBase
  source_root File.expand_path("templates", __dir__)

  def copy_templates
    template "controller.rb", "app/controllers/inbound_webhooks/#{file_path}_controller.rb"
    template "controller_test.rb", "test/controllers/inbound_webhooks/#{file_path}_controller_test.rb"
    template "job.rb", "app/jobs/inbound_webhooks/#{file_path}_job.rb"
    template "job_test.rb", "test/jobs/inbound_webhooks/#{file_path}_job_test.rb"
  end

  def routes
    route "resources :#{file_name}, controller: :#{file_name}, only: [:create]", namespace: [:inbound_webhooks] + regular_class_path
  end
end
