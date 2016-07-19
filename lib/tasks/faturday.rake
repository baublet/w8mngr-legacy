desc "Processes every user's faturdays and sets today as faturday if they have it pre-set as one"
task :faturday => :environment do
  puts "Processing automatic Faturday entries"
  CronProcessUserFaturdaysJob.perform_later
end