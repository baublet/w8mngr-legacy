class NotifyAdminOfNewUserJob < ActiveJob::Base
  queue_as :default

  def perform user_id

    # DO NOT send emails if we're running tests
    return if Rails.env.test?

    client = Postmark::ApiClient.new(ENV["W8MNGR_API_KEY_POSTMARK"])
    user = User.find(user_id)
    message = PtMessage.find(message_id)
    client.deliver_with_template({
     :from => "ryan@w8mngr.com",
     :to => "baublet@gmail.com",
     :HtmlBody => "Woohoo! We got a new user: " + user.email
    })

  end
end