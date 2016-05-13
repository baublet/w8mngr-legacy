class SendPtMessageJob < ActiveJob::Base
  queue_as :default

  def perform message_id
    client = Postmark::ApiClient.new(ENV["W8MNGR_API_KEY_POSTMARK"])
    message = PtMessage.find(message_id)
    user = message.user
    subject = subject.nil? ? "Message from w8mngr" : subject
    message_html = message.message_html.nil? ? message.message : message.message_html
    client.deliver_with_template({
     :from => "ryan@w8mngr.com",
     :to => user.email,
     :template_id => 623222,
     :template_model => {
       "name" => user.name,
       "message_html" => message_html,
       "message" => message.message,
       "subject" => subject
     }
    })
  end
end