class ActivityEntriesController < ApplicationController
  before_action :logged_in_user
  before_action :find_activity

  def index
    show_list
  end

  def create
    unless @activity.nil?
      @new_activityentry = current_user.activity_entries.build(activity_entries_params)
      if @new_activityentry.save
        flash.now[:success] = "Activity entry created!"
      else
        flash.now[:error] = "Unable to create activity entry..."
      end
      show_list
    else
      show_404 "Invalid activity entry..."
    end
  end

  def update
    find_activity_entry
    unless @activity_entry.nil?
      if @activity_entry.update(activity_entries_params)
        flash.now[:success] = "Activity entry updated."
      else
        flash.now[:error] = "Unable to update activity entry..."
      end
      show_list unless @activity_entry.nil?
    else
      show_404 "Invalid activity entry..." if @activity_entry.nil?
    end
  end

  def destroy
    find_activity_entry
    unless @activity_entry.nil?
      flash.now[:success] = "Activity entry deleted."
      @activity_entry.destroy
      show_list
    else
      show_404 "Invalid activity entry..."
    end
  end

  private

  def find_activity
    @activity = Activity.find(params[:activity_id]) rescue nil
    show_404 "Invalid activity..." if @activity.nil?
  end

  def find_activity_entry
    @activity_entry = current_user.activity_entries.find(params[:id])
  end

  def show_list
    # We don't want to even process anything else if we're on an invalid @activity
    unless @activity.nil?
      @new_activityentry ||= current_user.activity_entries.build(activity: @activity)
      @activityentries = current_user.activity_entries.where(activity_id: params[:activity_id])
      render "index"
    end
  end

  def activity_entries_params
    params.permit(:work, :reps, :routine_id, :activity_id, :day)
  end

end