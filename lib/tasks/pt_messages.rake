desc "Generates users' reminder messages"
task :generate_pt_messages => :environment do

  # puts "Generating reminder messages..."

  # Cycle through all users and apply our Personal Trainer modules to each person
  # TODO: Query this based on activity, rather than just all of the users
  User.find_each.each do |user|
    CronGenerateReminderMessagesJob.perform_later user.id
  end

end

desc "Delivers users' most recent unseen reminder message"
task :deliver_pt_messages => :environment do

  # puts "Delivering user reminder messages..."

  # Cycle through all users and send the most recent message to them
  # This task is intended to be called every hour
  User.find_each.each do |user|
    CronDeliverReminderMessagesJob.perform_later user.id
  end

end