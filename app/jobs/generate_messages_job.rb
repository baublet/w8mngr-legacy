class GenerateMessagesJob < ActiveJob::Base
  queue_as :default

  def perform(user_id)
    @user = User.find(user_id)
  end
end
