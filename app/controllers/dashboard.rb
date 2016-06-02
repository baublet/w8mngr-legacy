class DashboardController < ApplicationController
  before_action :logged_in_user

  def index
    @week_averages = current_user.week_average
  end
end