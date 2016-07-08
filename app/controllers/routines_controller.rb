class RoutinesController < ApplicationController

  before_action :logged_in_user
  before_action :find_routine, only: [:show, :edit, :update, :destroy, :add_activity, :remove_activity]
  before_action :find_activity, only: [:add_activity, :remove_activity]

  def index
    @routines = current_user.routines
  end

  def show

  end

  def edit

  end

  def new

  end

  def create
    routine = current_user.routines.build(routines_params)
    if routine.save
      redirect_to edit_routine_path routine
    else
      @routine = routine
      render "new"
    end
  end

  def update
    if @routine.update(routines_params)
      if params[:activities].is_a?(Array)
        error = false
        @routine = []
        params[:activities].each do |activity_id|
          activity = Activity.find(activity_id) rescue false
          error = true and break if !activity
          @routine << activity.id
        end
        if error
          flash.now[:error] = "Attempted to add an invalid activity to the routine..."
          render "edit"
        end
      end
      @routine.save unless (defined? error).nil?
      flash[:success] = "Routine updated!"
      redirect_to edit_routine_path @routine
    else
      flash.now[:error] = "Error saving routine..."
      render "edit"
    end
  end

  def destroy
    @routine.destroy
    redirect_to routines_path
  end

  def add_activity

  end

  def remove_activity

  end

  private

  def find_routine
    @routine = current_user.routines.find(params[:id]) rescue nil
    show_404 "Unable to find routine..." and return false if @routine.nil?
  end

  def find_activity
    @activity = current_user.activities.find(params[:activity_id]) rescue nil
    show_404("Unable to find the activity you were searching for...")  and return false if @activity.nil?
  end

  def routines_params
    params.require(:routine)
      .permit(:name, :description)
  end

end