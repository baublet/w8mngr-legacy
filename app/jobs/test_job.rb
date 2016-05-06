class TestJob
  def self.queue
    :default
  end

  def self.perform
    puts 'I like to sleep!'
    sleep 2
    Resque.enqueue(TestJob)
  end
end