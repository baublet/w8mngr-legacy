class UsersController < ApplicationController
    before_action :logged_in_user, only: [:show, :destroy, :update]
    before_action :correct_user, only: [:edit, :update, :destroy]

    def show
        respond_to do |format|
            format.html {
              @user = current_user
              render :show
            }
            format.json {
              id = current_user.id
              email = current_user.email
              preferences = current_user.preferences
              render json: {
                id: id,
                email: email,
                preferences: preferences
              }
            }
        end
    end

    def new
        @user = User.new
    end

    def create
        @user = User.new(user_params)
        if @user.save
            flash[:success] = "Welcome to w8mngr!"
            login @user
            redirect_to dashboard_path
        else
            render 'new'
        end
    end

    def update
        @user = User.find(params[:id])

        preferences = {}
        preferences["height_display"] = params["height_display"]
        preferences["sex"] = params["sex"]
        preferences["birthday"] = params["birthday"]
        preferences["timezone"] = params["timezone"]
        preferences["units"] = params["units"]
        preferences["name"] = params["name"]
        preferences["target_calories"] = params["target_calories"]
        preferences["activity_level"] = params["activity_level"]
        preferences["faturday_enabled"] = params["faturday_enabled"]
        preferences["auto_faturdays"] = {}
        if params.try(:[], "faturday")
          params["faturday"].each do |day|
            preferences["auto_faturdays"][day] = true
          end
        end
        preferences["faturday_calories"] = params["faturday_calories"]
        preferences["faturday_fat"] = params["faturday_fat"]
        preferences["faturday_carbs"] = params["faturday_carbs"]
        preferences["faturday_protein"] = params["faturday_protein"]
        preferences["differential_metric"] = params["differential_metric"]

        @user.set_preferences(preferences)

        if @user.save
          flash.now[:success] = "Preferences saved"
        else
          flash.now[:error] = "Unknown error saving preferences..."
        end
        render 'edit'
    end

    def edit
        @user = User.find(params[:id])
    end

    private

  def user_params
    params.require(:user)
        .permit(:email, :password, :password_confirmation)
  end

  def correct_user
    redirect_to root_url if current_user.id != params[:id].to_i
  end
end
