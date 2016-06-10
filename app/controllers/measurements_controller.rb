class MeasurementsController < ApplicationController
	before_action :logged_in_user

	def increment_popularity
	  respond_to do |format|
      format.json {
        id = params[:id].to_i
        measurement = Measurement.find(id)
        render json: {success: false} if measurement.nil?
        measurement.increment_popularity
        food = measurement.food
        food.increment_popularity
        render json: {success: true}
      }
    end
	end

end