class ActivitiesController < ApplicationController
  before_action :logged_in_user
  before_action :find_activity, only: [:edit, :update, :destroy]
  before_action :build_activity, only: [:new, :create]

  def index
    @activities = current_user.activities
  end

  def show
    # We do this here so anyone can view all activities added
    @activity = Activity.find(params[:id])
  end

  def new
  end

  def create
    @activity = current_user.activities.build(activities_params)
    if @activity.save
      redirect_to @activity
    else
      flash.now[:error] = "Error creating activity..."
    end
  end

  def edit
  end

  def update
    if @activity.update(activities_params)
      flash.now[:success] = "Activity updated!"
    else
      flash.now[:error] = "Error updating activity..."
    end
    render "edit"
  end

  def destroy
    @activity.deleted = true
    @activity.save
    flash.now[:success] = "Activity deleted."
    redirect_to activities_path
  end

  private

  def find_activity
    @activity = current_user.activities.find(params[:id])
  end

  def build_activity
    @activity = current_user.activities.build()
  end

  def activities_params
    params.require(:activity)
      .permit(:name, :description)
  end

end