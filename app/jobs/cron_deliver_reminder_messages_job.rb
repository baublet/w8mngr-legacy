class CronDeliverReminderMessagesJob < ActiveJob::Base
  queue_as :default

  def perform

    # puts "Delivering user reminder messages..."

    # Cycle through all users and send the most recent message to them
    # This task is intended to be called every hour or two
    User.find_each.each do |user|
      message = user.get_random_pt_message true
      next if message.nil?
      puts "Delivering messages for " + user.email
      SendPtMessageJob.perform_later message.id
    end

  end

end