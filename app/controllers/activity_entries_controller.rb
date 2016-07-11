class ActivityEntriesController < ApplicationController
  before_action :logged_in_user
  before_action :find_activity

  def index
    show_list
  end

  def create
    unless @activity.nil?
      @new_activityentry = current_user.activity_entries.build(activity_entries_params)
      convert_unit @new_activityentry
      if @new_activityentry.save
        flash[:success] = "Activity entry created!"
      else
        flash[:error] = "Unable to create activity entry..."
      end
       redirect_to activity_log_day_path(activity_id: params[:activity_id], day: current_day)
    else
      show_404 "Invalid activity entry..."
    end
  end

  def update
    find_activity_entry
    unless @activity_entry.nil?
      if @activity_entry.update(activity_entries_params)
        convert_unit @activity_entry
        flash[:success] = "Activity entry updated."
      else
        flash[:error] = "Unable to update activity entry..."
      end
      redirect_to activity_log_day_path(activity_id: params[:activity_id], day: current_day)
    else
      show_404 "Invalid activity entry..." if @activity_entry.nil?
    end
  end

  def destroy
    find_activity_entry
    unless @activity_entry.nil?
      flash[:success] = "Activity entry deleted."
      day = @activity_entry.day
      @activity_entry.destroy
      redirect_to activity_log_day_path(activity_id: params[:activity_id], day: day)
    else
      show_404 "Invalid activity entry..."
    end
  end

  private

  def find_activity
    @activity = Activity.find(params[:activity_id]) rescue nil
    show_404 "Invalid activity..." and return false if @activity.nil?
  end

  def find_activity_entry
    @activity_entry = current_user.activity_entries.find(params[:id])
  end

  def show_list
    # We don't want to even process anything else if we're on an invalid @activity
    unless @activity.nil?
      @activity_pr = current_user.activity_entries.where(activity_id: params[:activity_id]).order("work DESC").first
      @new_activityentry ||= current_user.activity_entries.build(activity: @activity)
      @activityentries = current_user.activity_entries.where(activity_id: params[:activity_id], day: current_day).order('created_at DESC')
      @olderactivityentries = ActivityEntry.recent_most(current_user.id, params[:activity_id], 5)
      render "index"
    end
  end

  def activity_entries_params
    params.permit(:reps, :routine_id, :activity_id, :day)
  end

  def convert_unit entry
    work_g = params[:work].to_unit.convert_to("g").scalar.to_i rescue false
    work_g = (params[:work] + current_user.unit).to_unit.convert_to("g").scalar.to_i rescue false if work_g == false
    return false if work_g == false
    entry.work = work_g
    return true
  end

end