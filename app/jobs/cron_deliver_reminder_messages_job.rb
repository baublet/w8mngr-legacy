class CronDeliverReminderMessagesJob < ActiveJob::Base
  queue_as :default

  def perform

    # Cycle through all users and send the most recent message to them
    # This task is intended to be called every hour or two
    User.find_each.each do |user|
      message = user.get_random_pt_message true
      next if message.nil?
      SendPtMessageJob.perform_later message.id
    end

  end

end