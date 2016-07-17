desc "Processes every user's faturdays and sets today as faturday if they have it pre-set as one"
task :faturday => :environment do
  # puts "Processing automatic Faturday entries"
  User.find_each.each do |user|
    next if user.preferences["faturday_enabled"] == "false"
    CronProcessUserFaturdaysJob.perform_later user.id
  end
end