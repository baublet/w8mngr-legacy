class FoodEntriesController < ApplicationController
	before_action :logged_in_user, only: [:create, :destroy, :update]
	before_action :correct_user, only: [:update, :destroy]

	include FoodsHelper

	def index
		respond_to do |format|
      format.html { show_list }
      format.json { show_list :json }
    end
	end

	def create
		@newfoodentry = current_user.foodentries.build(food_entry_params)
		if @newfoodentry.save
			@newfoodentry = nil
		end
		show_list
	end

	def update
		@foodentry = current_user.foodentries.find(params[:id])
		if !@foodentry.nil?
			if @foodentry.update(food_entry_params)
				flash.now[:success] = "Entry successfully updated."
			end
		else
			flash.now[:error] = "You cannot edit another user's entries!"
		end
		show_list
	end

	def destroy
		@foodentry = current_user.foodentries.find(params[:id])
		@current_day = @foodentry.day
		@foodentry.destroy
		show_list
	end

	# Adds a food to the user's last-viewed day (or the current day) based on measurement (its id) and the amount as a multiplier to the measurement
	def add_food
		# Validate the day
		@day = !cookies[:last_day].present? ? current_day : validate_day(cookies[:last_day])
		# Load up the food in this entry
		@food_entry = current_user.foodentries.build(day: @day)
		@food_entry.populate_with_food(params[:measurement].to_i, params[:amount])
		if @food_entry.save
			# Redirect them back to that day
			flash[:success] = "Added food to your log!"
			increment_popularity params[:food_id].to_i, params[:measurement].to_i
		else
			# TODO: Log this behavior
			flash[:error] = "Error adding the food to your log"
			# puts YAML::dump(@food_entry)
		end
		redirect_to food_log_day_path(@day)
	end

	private

	def food_entry_params
		params.require(:food_entry)
			  .permit(:description, :calories, :fat, :carbs, :protein, :day)
	end

	def correct_user
		@foodentry = current_user.foodentries.find_by(id: params[:id])
		redirect_to root_url if @foodentry.nil?
	end

	def show_list format = :html
		# Saves the last viewed day in a cookie
		cookies[:last_day] = current_day
		@foodentries = current_user.foodentries_from(current_day)
		if format == :html
			@totals = current_user.food_totals(current_day)
			@newfoodentry ||= current_user.foodentries.build(day: current_day, calories: nil)
			render 'index'
		else
			render json: {current_day: current_day, entries: @foodentries}
		end
	end
end
