class RoutinesController < ApplicationController

  before_action :logged_in_user
  before_action :find_routine, only: [:show, :edit, :update, :destroy, :add_activity, :remove_activity]
  before_action :find_activity, only: [:add_activity, :remove_activity]

  def index

  end

  def show

  end

  def edit
  end

  def create
  end

  def update
  end

  def destroy

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

end