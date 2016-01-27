class FoodEntriesController < ApplicationController
	before_action :logged_in_user, only: [:create, :destroy, :update]
	before_action :correct_user, only: [:update, :destroy]

	def index
		@foodentries = current_user.foodentries.where(day: current_day) || current_user.foodentries.none
		@newfoodentry = current_user.foodentries.build(day: current_day)
		@total_calories = @foodentries.map{|f| f['calories']}.compact.reduce(0, :+)
		@total_fat = @foodentries.map{|f| f['fat']}.compact.reduce(0, :+)
		@total_carbs = @foodentries.map{|f| f['carbs']}.compact.reduce(0, :+)
		@total_protein = @foodentries.map{|f| f['protein']}.compact.reduce(0, :+)
	end

	def create
		@foodentry = current_user.foodentries.build(food_entry_params)
		if @foodentry.save
			redirect_to '/foodlog/' + params[:food_entry][:day]
		else
			@foodentries = current_user.foodentries.where(day: current_day) || current_user.foodentries.none
			@newfoodentry = current_user.foodentries.build(day: current_day)
			render 'index'
		end
	end

	def update
		@foodentry = current_user.foodentries.find(params[:id])
		if @foodentry.update(food_entry_params)
			redirect_to '/foodlog/' + params[:food_entry][:day]
		else
			@newfoodentry = current_user.foodentries.build(day: current_day)
			render 'index'
		end
	end

	def destroy
		@foodentry = current_user.foodentries.find(params[:id])
		day = @foodentry[:day]
		@foodentry.destroy
		redirect_to '/foodlog/' + day.to_s
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
end
