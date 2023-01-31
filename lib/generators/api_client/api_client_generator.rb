class ApiClientGenerator < Rails::Generators::NamedBase
  source_root File.expand_path("templates", __dir__)

  def copy_templates
    template "client.rb", "app/clients/#{file_path}_client.rb"
    template "client_test.rb", "test/clients/#{file_path}_client_test.rb"
  end
end
