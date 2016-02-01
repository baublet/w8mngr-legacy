class FoodEntriesController < ApplicationController
	before_action :logged_in_user, only: [:create, :destroy, :update]
	before_action :correct_user, only: [:update, :destroy]

	def index
		show_list
	end

	def create
		@newfoodentry = current_user.foodentries.build(food_entry_params)
		if @newfoodentry.save
			@newfoodentry = current_user.foodentries.where(day: current_day)
		end
		show_list
	end

	def update
		@foodentry = current_user.foodentries.find(params[:id])
		if !@foodentry.nil?
			if @foodentry.update(food_entry_params)
				flash[:success] = "Entry successfully updated."
			end
		else
			flash[:error] = "You cannot edit another user's entries!"
		end
		show_list
	end

	def destroy
		@foodentry = current_user.foodentries.find(params[:id])
		day = @foodentry[:day]
		@foodentry.destroy
		show_list
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

		@newfoodentry ||= current_user.foodentries.build(day: current_day)
		render 'index'
	end
end
