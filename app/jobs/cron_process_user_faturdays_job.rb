class CronProcessUserFaturdaysJob < ActiveJob::Base
  queue_as :default

  def perform user_id

    user = User.find(user_id)

    today = Date.today

    day_token = today.strftime("%a").downcase.byteslice(0,2)
    return false if user.preferences["auto_faturdays"].nil?
    return false if user.preferences["auto_faturdays"][day_token].nil?
    return false if user.preferences["auto_faturdays"][day_token] == "false"

    # If the user has an entry for this day, don't add the faturday
    today = today.strftime('%Y%m%d')
    existing = user.foodentries.where(day: today).limit(1)
    return false if !existing.nil?

    new_entry = user.foodentries.build(day: today)
    new_entry.description = "Faturday!"
    new_entry.calories = user.preferences["faturday_calories"]
    new_entry.fat = user.preferences["faturday_fat"]
    new_entry.carbs = user.preferences["faturday_carbs"]
    new_entry.protein = user.preferences["faturday_protein"]

    if new_entry.save
      #puts "Added faturday automatically for " + user.name
    else
      #puts "Failed to add Faturday for " + user.name + ". Likely because they didn't enter proper default values."
    end
  end
end