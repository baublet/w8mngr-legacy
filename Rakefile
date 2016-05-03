# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks

# Adding test/modules directory to rake test.
namespace :test do
  desc "Test our modules code"
  Rails::TestTask.new(modules: 'test:prepare') do |t|
    t.pattern = 'test/modules/*_test.rb'
  end
end

Rake::Task['test:run'].enhance ["test:modules"]