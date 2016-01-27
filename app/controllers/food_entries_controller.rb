class FoodEntriesController < ApplicationController
	before_action :logged_in_user, only: [:create, :destroy]
	before_action :correct_user, only: [:update, :destroy]

	def index
		@foodentries = current_user.foodentries.where(day: current_day) || current_user.foodentries.none
		@foodentry = current_user.foodentries.build(day: current_day)
	end

	def show
		@foodentry = current_user.foodentries.find(params[:id])
	end

	def new
		@foodentry = current_user.foodentries.build
	end

	def create
		@foodentry = current_user.foodentries.build(food_entry_params)
		if @foodentry.save
			@foodentries = current_user.foodentries.where(day: current_day) || current_user.foodentries.none
			@foodentry = current_user.foodentries.build(day: current_day)
			render 'index'
		else
			render 'new'
		end
	end

	def edit
		@foodentry = current_user.foodentries.find(params[:id])
	end

	def update
		@foodentry = current_user.foodentries.find(params[:id])

		if @foodentry.update(food_entry_params)
			redirect_to food_entries_path
		else
			render 'edit'
		end
	end

	def destroy
		@foodentry = current_user.foodentries.find(params[:id])
		@foodentry.destroy

		redirect_to food_entries_path
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
