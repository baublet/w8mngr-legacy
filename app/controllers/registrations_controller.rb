class RegistrationsController < ApplicationController
  before_action :logged_in_user, only: [:set_metrics, :save_metrics, :set_target, :save_target]

  def new
    @user = User.new
  end

  # Creates the user's account
  def create
    @user = User.new(user_params)
    if @user.save
      login @user
      render "calculate"
    else
      render "new"
    end
  end

  # Screen 2, allowing the user to submit their measurements to calculate their TDEE
  def set_metrics
    @user = current_user
    render "set_metrics"
  end

  # Accepts a list of params that the user submits to calculate their TDEE
  def save_metrics
    @user = current_user
    begin
      height_cm = params["height_display"].to_unit.convert_to("cm").scalar.to_i
    rescue
      height_cm = nil
    end
    date_time = Chronic.parse(params["birthday"])
    @user.preferences["height_display"] = params["height_display"]
    @user.preferences["height"] = height_cm.to_s
    @user.preferences["sex"] = params["sex"]
    @user.preferences["birthday"] = date_time.nil? ? "" : date_time.strftime("%B %-d, %Y")
    activity_level = params["activity_level"].to_i
    @user.preferences["activity_level"] = activity_level.between?(1,5) ? activity_level : 2

    if @user.save
      render "target"
    else
      render "metrics"
    end
  end

  # Shows the user the form to set their target along with the TDEE (if we can calculate it)
  def set_target
    @user = current_user
    render "target"
  end

  # Sets the user's target weight based on the TDEE calculated above
  def save_target
    @user = current_user
    @user.preferences["target_calories"] = target_calories > 300 ? target_calories : ""
    if @user.save
      redirect_to foodlog_path
    else
      render "target"
    end
  end

  private

  def user_params
    params.require(:user)
        .permit(:email, :password, :password_confirmation)
  end
end