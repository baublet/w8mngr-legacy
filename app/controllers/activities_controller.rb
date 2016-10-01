class ActivitiesController < ApplicationController
  before_action :logged_in_user
  before_action :find_activity, only: [:show, :edit, :update, :destroy]

  def index
    @activities = load_activities_from current_user
  end

  # A list for our curated database of activities, based on the first user's
  # list of activities (which is the admin). TODO: Find a better way to do this
  # when I setup a true administration panel and interface
  def database
    @activities = load_activities_from User.first
  end

  def show
    @activity_description = MarkdownText.render_basic(@activity.description) unless @activity.nil?
  end

  def new
    @activity = current_user.activities.build()
  end

  def create
    @activity = current_user.activities.build(activities_params)
    @activity.update_muscle_groups params[:activity]["muscle_groups"]
    if @activity.save
      flash[:success] = "Activity created!"
      redirect_to @activity
    else
      flash.now[:error] = "Error creating activity..."
    end
  end

  def edit
  end

  def update
    if @activity.update(activities_params) &&
        @activity.update_muscle_groups(params[:activity]["muscle_groups"]) &&
        @activity.save
      flash.now[:success] = "Activity updated!"
    else
      flash.now[:error] = "Error updating activity..."
    end
    render "edit"
  end

  def destroy
    show_404("Unable to find the activity you were searching for...") and return false if @activity.user_id != current_user.id
    @activity.deleted = true
    @activity.save
    flash[:success] = "Activity deleted."
    redirect_to activities_path
  end

  private

  def find_activity
    @activity = Activity.find(params[:id]) rescue nil
    show_404("Unable to find the activity you were searching for...")  and return false if @activity.nil?
  end

  def activities_params
    params.require(:activity)
      .permit(:name, :description, :exrx, :activity_type, :intensity)
  end

  # Uses all of our filters to load the entries for the passed user
  def load_activities_from user
    activities = Activity.belonging_to_user user
    groups = params.try(:[], :activity).try(:[], :muscle_groups)
    if groups.is_a? Hash
      like_string = Activity::muscle_groups_like groups
      activities = activities.where("muscle_groups LIKE ?", like_string)
    end
    q = params.try(:[], :q).nil? ? "" : params.try(:[], :q)
    unless q.empty?
      activities = activities.search_activities q
    end
    return activities
  end

end