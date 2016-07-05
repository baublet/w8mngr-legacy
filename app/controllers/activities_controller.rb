class ActivitiesController < ApplicationController
  before_action :logged_in_user
  before_action :find_activity, only: [:edit, :update, :destroy]

  def index
    @activities = current_user.activities
  end

  def show
    # We do this here so anyone can view all activities
    @activity = Activity.find(params[:id])
    html_renderer = Redcarpet::Render::HTML.new(
      filter_html: true,
      no_images: true,
      no_links: true,
      no_styles: true
      )
    markdown = Redcarpet::Markdown.new(html_renderer)
    @activity_description = markdown.render(@activity.description)
  end

  def new
    @activity = current_user.activities.build()
  end

  def create
    @activity = current_user.activities.build(activities_params)
    @activity.save_muscle_groups params[:activity]["muscle_groups"]
    if @activity.save
      redirect_to @activity
    else
      flash.now[:error] = "Error creating activity..."
    end
  end

  def edit
  end

  def update
    if @activity.update(activities_params) &&
        @activity.save_muscle_groups(params[:activity]["muscle_groups"]) &&
        @activity.save
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

  def activities_params
    params.require(:activity)
      .permit(:name, :description, :exrx, :activity_type)
  end

end