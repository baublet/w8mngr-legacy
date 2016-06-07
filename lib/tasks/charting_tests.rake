
task :chart => :environment do
  # This will group all of the days in the database
  id = User.first.id
  data = FoodEntryData.new(user_id: id)
  data.length_scope = "day"
  data.length = 30
  days = data.time_data

  days.each do |day, total|
    puts "Day of " + day.to_s + " ---> " + total.to_i.to_s
  end

  data.length_scope = "week"
  data.length = 12
  weeks = data.time_data

  weeks.each do |week, average|
    puts "Week of " + week.to_s + " ---> " + average.to_i.to_s
  end

  data.length_scope = "month"
  data.length = 6
  months = data.time_data

  months.each do |month,  average|
    puts "Month of " + month.to_s + " ---> " + average.to_i.to_s
  end

  data.length_scope = "year"
  data.length = 3
  years = data.time_data

  years.each do |year,  average|
    puts "Year of " + year.to_s + " ---> " + average.to_i.to_s
  end
end