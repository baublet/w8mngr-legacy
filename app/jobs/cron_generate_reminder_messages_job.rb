class CronGenerateReminderMessagesJob < ActiveJob::Base
  queue_as :default

  def perform user_id
    user = User.find(user_id)
    messages = PersonalTrainer::Analyze::user user
    # No messages? do nothing
    return false if messages.count == 0
    # Add the messages to our database
    # puts "Saving messages for " + user.name
    user.save_pt_messages messages
  end

end