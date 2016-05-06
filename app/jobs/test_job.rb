class TestJob < ActiveJob::Base
  queue_as :default

  def perform
    puts 'I like to sleep!'
    sleep 2
  end
end