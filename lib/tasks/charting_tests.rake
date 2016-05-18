
task :chart => :environment do
  # This will group all of the days in the database
  days = User.first.foodentries.group_by_day(:day_ts, last: 360).sum(:calories)
  overall_average = days.map(&:last).inject(:+) / days.size
  min = overall_average * 0.666
  puts "Overall average: " + overall_average.to_s
  # Filter out all underlier days
  # days = Hash[days.select { |k,v| v > min }]
  weeks = days.group_by_week() { |d| d[0] }
  week_averages = Hash[weeks.map { |k,v| [k, v.map(&:last).inject(:+) / v.size] }]
  #week_averages = Hash[week_averages.select { |k,v| v > min }]
  months = days.group_by_month { |d| d[0] }
  month_averages = Hash[months.map { |k,v| [k, v.map(&:last).inject(:+) / v.size] }]
  week_averages.each do |week, average|
    puts "Week of " + week.to_s + " ---> " + average.to_i.to_s
  end
  month_averages.each do |month,  average|
    puts "Month of " + month.to_s + " ---> " + average.to_i.to_s
  end
end