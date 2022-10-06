namespace :stimulus do
  desc "Overwrites the default manifest update behavior to do nothing"
  namespace :manifest do
    # clearing the :update task to skip default behavior from stimulus-rails gem
    Rake::Task[:update].clear
    task update: :environment do
      alert = %(
        Skipping stimulus:manifest:update to avoid overwriting stimulus controllers shipped with Jumpstart Pro.
      ).strip
      puts "\e[33m#{alert}\e[0m"
    end
  end
end
