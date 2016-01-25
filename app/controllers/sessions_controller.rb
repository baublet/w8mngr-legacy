class SessionsController < ApplicationController
  def new

  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
        login user
        remember user
        redirect_to user
    else
        flash[:danger] = 'Invalid email/password combination'
        render 'new'
    end
  end

  def destroy
    logout
    redirect_to root_url
  end
end
