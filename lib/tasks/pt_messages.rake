desc "Generates users' reminder messages"
task :generate_pt_messages => :environment do

  puts "Generating reminder messages..."

  # Cycle through all users and apply our Personal Trainer modules to each person
  # TODO: Query this based on activity, rather than just all of the users
  User.find_each.each do |user|
    puts "Generating messages for " + user.email
    messages = PersonalTrainer::Analyze::user user
    # Add the messages to our database
    next if messages.count == 0
    user.save_pt_messages messages
  end

end

desc "Delivers users' most recent unseen reminder message"
task :deliver_pt_messages => :environment do

  puts "Delivering user reminder messages..."

  # Cycle through all users and send the most recent message to them
  # This task is intended to be called every hour
  User.find_each.each do |user|
    message = user.get_random_pt_message true
    next if message.nil?
    puts "Delivering messages for " + user.email
    SendPtMessageJob.perform_later message.id
  end

end