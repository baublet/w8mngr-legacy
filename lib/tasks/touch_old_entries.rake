desc "Touches all old food and weight entries and saves them with the appropriate day_ts timestamp value"
task :touch_old_entries => :environment do
  ActiveRecord::Base.transaction do
    x = 1
    FoodEntry.find_each do |entry|
      entry.day_ts = Date.strptime(entry.day.to_s,"%Y%m%d")
      entry.save
      puts "Touching FoodEntry " + x.to_s
      x += 1
    end
    x = 1
    WeightEntry.find_each do |entry|
      entry.day_ts = Date.strptime(entry.day.to_s,"%Y%m%d")
      entry.save
      puts "Touching WeightEntry " + x.to_s
      x += 1
    end
  end
end