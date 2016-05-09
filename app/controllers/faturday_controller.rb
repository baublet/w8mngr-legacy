class FaturdayController < ApplicationController
  before_action :logged_in_user, only: [:create]
  def create
    day = validate_day(params["day"])
    fd_enabled = current_user.preferences["faturday_enabled"] ? true : false
    fd_vals = (current_user.preferences["faturday_calories"] || current_user.preferences["faturday_fat"] ||
               current_user.preferences["faturday_carbs"]    || current_user.preferences["faturday_protein"])?
               true : false
    if fd_enabled && fd_vals
      new_entry = current_user.foodentries.build(day: day)
      new_entry.description = "Faturday!"
      new_entry.calories = current_user.preferences["faturday_calories"]
      new_entry.fat = current_user.preferences["faturday_fat"]
      new_entry.carbs = current_user.preferences["faturday_carbs"]
      new_entry.protein = current_user.preferences["faturday_protein"]

      if new_entry.save
        respond_to do |format|
          format.html {
            flash[:success] = "Faturday saved. Enjoy your day off!"
            redirect_to food_log_day_path day
          }
          format.json { render json: {success: true, entry: new_entry} }
        end
      else
        respond_to do |format|
          format.html {
            flash[:error] = "Unknown error adding Faturday..."
            redirect_to foodlog_path
          }
          format.json { render json: {success: false, message: "Unknown error adding Faturday..."} }
        end
      end
    else
      # If faturdays are off, or there isn't any option for faturdays set, do nothing
      # and show them an error
      respond_to do |format|
          format.html {
            flash[:error] = "You haven't setup Faturdays properly, yet..."
            redirect_to edit_user_path current_user
          }
          format.json { render json: {success: false, message: "You haven't setup Faturdays properly, yet..." } }
        end
    end
  end
end
