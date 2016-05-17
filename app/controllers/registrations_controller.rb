class RegistrationsController < ApplicationController
  before_action :logged_in_user, only: [:set_metrics, :save_metrics, :set_target, :save_target]

  def new
    redirect_to get_started_calculate_path if logged_in?
    @user = User.new
  end

  # Creates the user's account
  def create
    @user = User.new(user_params)
    if @user.save
      login @user
      @weightentry = @user.weightentries.build(day: current_day)
      render "metrics"
    else
      render "new"
    end
  end

  # Screen 2, allowing the user to submit their measurements to calculate their TDEE
  def set_metrics
    @user = current_user
    recent = @user.recent_most_weight
    @weightentry = recent.nil? ? @user.weightentries.build(day: current_day) : recent
    render "metrics"
  end

  # Accepts a list of params that the user submits to calculate their TDEE
  def save_metrics
    @user = current_user

    # Save their preferences
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

    # Save their new weight
    if !params[:weight].blank?
      @weightentry = @user.weightentries.build(day: current_day)
      @weightentry.update_value params[:weight]
    end

    if @user.save
      if params[:weight].blank?
        render "target"
      else
        if @weightentry.save
          render "target"
        else
          render "metrics"
        end
      end
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
    target_calories = params[:target_calories].present? ? params[:target_calories].to_i : 0
    @user.preferences["target_calories"] = target_calories > 300 ? target_calories : ""
    if @user.save
      flash[:success] = "Congrats! Now get started logging your calories."
      redirect_to foodlog_path
    else
      render "target"
    end
  end

  private

  def user_params
    params.permit(:email, :password, :password_confirmation)
  end
end