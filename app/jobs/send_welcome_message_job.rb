class SendWelcomeMessageJob < ActiveJob::Base
  queue_as :default

  def perform user_id

    # DO NOT send emails if we're running tests
    return if Rails.env.test?

    client = Postmark::ApiClient.new(ENV["W8MNGR_API_KEY_POSTMARK"])
    user = User.find(user_id)

    client.deliver_with_template({
     :from => "ryan@w8mngr.com",
     :to => user.email,
     :template_id => 969581,
     :template_model => {}
    })

  end
end