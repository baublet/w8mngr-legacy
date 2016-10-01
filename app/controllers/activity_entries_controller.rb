require "chronic_duration"

class ActivityEntriesController < ApplicationController
  before_action :logged_in_user
  before_action :find_activity

  def index
    show_list
  end

  def create
    # Break the activity reps into x by x (e.g., 2x10, indicating two sets of 10)
    # so users can enter multiple sets in a single go
    entries = params[:reps].nil? ? [params[:reps]] : params[:reps].split('x')
    sets = entries.count > 1 ? entries[0].to_i : 1
    reps = entries.count > 1 ? entries[1].to_i : entries[0].to_i
    sets.times do
      @new_activityentry = current_user.activity_entries.build(activity_entries_params)
      @new_activityentry.reps = reps
      @new_activityentry.convert_unit_for_save reps, params[:work]
      if @new_activityentry.save
        flash[:success] = "Activity entry created!"
      else
        flash[:error] = "Unable to create activity entry..."
        break
      end
    end
    redirect_to activity_log_day_path(activity_id: params[:activity_id], day: current_day) if params.try(:[], :from_routine_id).nil?
    redirect_to routine_day_path(params.try(:[], :from_routine_id), current_day) unless params.try(:[], :from_routine_id).nil?
  end

  def update
    return false unless find_activity_entry
    unless @activity_entry.nil?
      if @activity_entry.update activity_entries_params
        @activity_entry.convert_unit_for_save params[:reps], params[:work]
        @activity_entry.save
        flash[:success] = "Activity entry updated."
      else
        flash[:error] = "Unable to update activity entry..."
      end
      redirect_to activity_log_day_path(activity_id: params[:activity_id], day: current_day) if params.try(:[], :from_routine_id).nil?
      redirect_to routine_day_path(params.try(:[], :from_routine_id), current_day) unless params.try(:[], :from_routine_id).nil?
    else
      show_404 "Invalid activity entry..." if @activity_entry.nil?
    end
  end

  def destroy
    return false unless find_activity_entry
    unless @activity_entry.nil?
      flash[:success] = "Activity entry deleted."
      day = @activity_entry.day
      @activity_entry.destroy
      redirect_to activity_log_day_path(activity_id: params[:activity_id], day: day) if params.try(:[], :from_routine_id).nil?
      redirect_to routine_day_path(params.try(:[], :from_routine_id), current_day) unless params.try(:[], :from_routine_id).nil?
    else
      show_404 "Invalid activity entry..."
    end
  end

  private

  def find_activity
    @activity = Activity.find(params[:activity_id]) rescue nil
    show_404("Invalid activity...") and return false if @activity.nil?
    return true
  end

  def find_activity_entry
    @activity_entry = current_user.activity_entries.find(params[:id]) rescue nil
    # We do this because these errors are always caused by users using the back button
    # after deleting an entry.
    redirect_to activity_log_day_path(params[:activity_id], current_day) and return false if @activity_entry.nil?
    return true
  end

  def show_list
    # We don't want to even process anything else if we're on an invalid @activity
    unless @activity.nil?
      @new_activityentry ||= current_user.activity_entries.build(activity: @activity)
      @activityentries = current_user.activity_entries.where(activity_id: params[:activity_id], day: current_day).order('created_at DESC')
      @olderactivityentries = ActivityEntry.recent_most(current_user.id, params[:activity_id], 5, 0, current_day.to_i)
      render "index"
    end
  end

  def activity_entries_params
    params.permit(:routine_id, :activity_id, :day)
  end

end