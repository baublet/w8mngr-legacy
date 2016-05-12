class SendPtMessageJob < ActiveJob::Base
  queue_as :default

  def perform message_id
    client = Postmark::ApiClient.new(ENV["W8MNGR_API_KEY_POSTMARK"])
    message = PtMessage.find(message_id)
    user = message.user
    puts "Sending PT message to " + user.email
    client.deliver_with_template(
      from:"ryan@w8mngr.com",
      to: user.email,
      template_id: 614082,
      template_model: {
        message: message.message
      }
    )
  end
end