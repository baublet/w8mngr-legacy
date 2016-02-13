class FoodEntriesController < ApplicationController
	before_action :logged_in_user, only: [:create, :destroy, :update]
	before_action :correct_user, only: [:update, :destroy]
	
	include FoodsHelper

	def index
		show_list
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
		day = @foodentry[:day]
		@foodentry.destroy
		show_list
	end
	
	# Adds a food to the user's selected log (or the current day) based on measurement (its id) and the amount as a multiplier to the measurement
	def add_food
		# Validate the day
		@day = params[:day].blank? ? current_day : validate_day(params[:day])
		# Validate the measurement amount ("1" if empty/blank)
		amount = params[:amount].blank? ? 1 : validate_measurement(params[:amount])
		# Load up the food
		@food = Food.find(params[:food_id].to_i)
		# Did they pass a valid measurement?
		measurement = @food.measurements.find(params[:measurement].to_i)
		if !measurement.nil?
			# Multiply the values properly
			calories = measurement.calories * amount
			fat = measurement.fat * amount
			carbs = measurement.carbs * amount
			protein = measurement.protein * amount
			# Add the entry to their food log
			@food_entry = current_user.foodentries.build(
				day: @day,
				description: "(#{amount} #{measurement.unit}) " + @food.name,
				calories: calories.to_i,
				fat: fat.to_i,
				carbs: carbs.to_i,
				protein: protein.to_i
			)
			
			if @food_entry.save
				# Redirect them back to that day
				flash[:success] = "Added food to your log!"
				increment_popularity params[:food_id].to_i, params[:measurement].to_i
			else
				# TODO: Log this behavior
				flash[:error] = "Error adding the food to your log!"
			end
			redirect_to food_log_day_path(@day)
		else
			render "foods/show"
		end
	end

	private

	def food_entry_params
		params.require(:food_entry)
			  .permit(:description, :calories, :fat, :carbs, :protein, :day, :user_id)
	end

	def correct_user
		@foodentry = current_user.foodentries.find_by(id: params[:id])
		redirect_to root_url if @foodentry.nil?
	end

	def show_list
		@foodentries = current_user.foodentries.where(day: current_day) || current_user.foodentries.none
		@total_calories = @foodentries.map{|f| f['calories']}.compact.reduce(0, :+)
		@total_fat = @foodentries.map{|f| f['fat']}.compact.reduce(0, :+)
		@total_carbs = @foodentries.map{|f| f['carbs']}.compact.reduce(0, :+)
		@total_protein = @foodentries.map{|f| f['protein']}.compact.reduce(0, :+)

		@newfoodentry ||= current_user.foodentries.build(day: current_day, calories: nil)
		render 'index'
	end
end
