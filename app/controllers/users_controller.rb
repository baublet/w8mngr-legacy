class UsersController < ApplicationController
    before_action :logged_in_user, only: [:destroy, :update]
    before_action :correct_user, only: [:show, :edit, :update, :destroy]

    def show
        @user = User.find(params[:id])
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
        @user.preferences["birthday"] = date_time.nil? ? params["birthday"] : date_time.strftime("%B %-d, %Y")
        @user.preferences["timezone"] = params["timezone"]
        @user.preferences["units"] = params["units"]
        @user.preferences["name"] = params["name"]

        @user.preferences["target_calories"] = params["target_calories"].to_i
        activity_level = params["activity_level"].to_i
        @user.preferences["activiy_level"] = activity_level.between?(1,10) ? activity_level : 1

        if @user.save
            flash.now[:success] = "Preferences saved"
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
