class NotifyAdminOfNewUserJob < ActiveJob::Base
  queue_as :default

  def perform user_id

    # DO NOT send emails if we're running tests
    return if Rails.env.test?

    client = Postmark::ApiClient.new(ENV["W8MNGR_API_KEY_POSTMARK"])
    user = User.find(user_id)

    puts "Running new user admin message: " + user.email
    client.deliver({
     :from => "ryan@w8mngr.com",
     :to => "baublet@gmail.com",
     :subject => "w8mngr: new user",
     :html_body => "Woohoo! We got a new user: " + user.email
    })

  end
end