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
            redirect_to @user
        else
            render 'new'
        end
    end

    def update
        @user = User.find(params[:id])

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
        @user.preferences["timezone"] = params["timezone"]
        @user.preferences["units"] = params["units"]
        @user.preferences["name"] = params["name"]

        target_calories = params["target_calories"].to_i
        @user.preferences["target_calories"] = target_calories > 300 ? target_calories : ""
        activity_level = params["activity_level"].to_i
        @user.preferences["activity_level"] = activity_level.between?(1,5) ? activity_level : 2

        @user.preferences["faturday_enabled"] = params["faturday_enabled"] ? true : false

        # Empty the existing faturday array
        @user.preferences["auto_faturdays"] = {}
        if params.try(:[], "faturday")
          params["faturday"].each do |day|
            @user.preferences["auto_faturdays"][day] = true
          end
        end

        @user.preferences["faturday_calories"] = params["faturday_calories"].to_i
        @user.preferences["faturday_fat"] = params["faturday_fat"].to_i
        @user.preferences["faturday_carbs"] = params["faturday_carbs"].to_i
        @user.preferences["faturday_protein"] = params["faturday_protein"].to_i

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
