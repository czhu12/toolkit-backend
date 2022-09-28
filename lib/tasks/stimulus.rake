namespace :stimulus do
  desc "Overwrites the default manifest update behavior to do nothing"
  namespace :manifest do
    # clearing the :update task is what skips the default behavior from the
    # stimulus-rails gem
    Rake::Task[:update].clear
    task update: :environment do
      print 'Skipping manifest update'
    end
  end
end