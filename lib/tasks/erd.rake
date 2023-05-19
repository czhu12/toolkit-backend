def which(cmd)
  exts = ENV["PATHEXT"] ? ENV["PATHEXT"].split(";") : [""]
  ENV["PATH"].split(File::PATH_SEPARATOR).each do |path|
    exts.each do |ext|
      exe = File.join(path, "#{cmd}#{ext}")
      return exe if File.executable?(exe) && !File.directory?(exe)
    end
  end
  nil
end

namespace :jumpstart do
  desc "Run rails-erd to generate docs/erd.pdf (Requires rails-erd and graphviz to be installed)"
  task :erd do
    Bundler.with_original_env do
      `erd`
    end
  end
end

# Uncomment if you'd like to update the erd diagram anytime migrations are run
# if which("erd") && Rake::Task.task_defined?("db:migrate")
#   Rake::Task["db:migrate"].enhance do
#     Rake::Task["jumpstart:erd"].invoke
#   end
# end
