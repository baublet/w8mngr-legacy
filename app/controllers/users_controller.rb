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
        @user = current_user
        @user.option["user.timezone"] = params["user.timezone"]
        height_unit = params["user.height_display"].to_unit
        height_cm = height_unit.convert_to('cm').round.scalar.to_i
        if height_cm > 20 && height_cm < 280
            @user.option["user.height_display"] = params["user.height_display"]
            @user.option["user.height"] = height_cm.to_s
        end
        @user.options["user.sex"] = params["user.sex"]

        @user.save_options
        render 'edit'
    end

    def edit
        @user = current_user
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
