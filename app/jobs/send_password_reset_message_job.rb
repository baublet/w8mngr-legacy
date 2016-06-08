class SendPasswordResetMessageJob < ActiveJob::Base
  queue_as :default

  def perform user_id, reset_token
    client = Postmark::ApiClient.new(ENV["W8MNGR_API_KEY_POSTMARK"])
    user = User.find(user_id)
    client.deliver_with_template({
       :from => "ryan@w8mngr.com",
       :to => user.email,
       :template_id => 592061,
       :template_model => {
          "name" => user.name,
          "action_url" => Rails.application.routes.url_helpers.edit_password_reset_url(reset_token, email: user.email, host: Rails.configuration.x.host)
        }
    })
  end
end