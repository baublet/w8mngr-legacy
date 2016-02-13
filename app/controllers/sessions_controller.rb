class SessionsController < ApplicationController
  def new

  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
        login user
        remember user
        if session[:forwarding_url]
            redirect_to session[:forwarding_url]
        else
            redirect_to user
        end
    else
        flash.now[:error] = 'Invalid email/password combination'
        render 'new'
    end
  end

  def destroy
    logout
    redirect_to root_url
  end
end
