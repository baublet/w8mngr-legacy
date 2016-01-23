class FoodEntriesController < ApplicationController
	def index
		@foodentries = FoodEntry.all
		@foodentry = FoodEntry.new
	end
	
	def show
		@foodentry = FoodEntry.find(params[:id])
	end
	
	def new
		@foodentry = FoodEntry.new
	end
	
	def create
		@foodentry = FoodEntry.new(food_entry_params)
 
		if @foodentry.save
			redirect_to food_entries_path
		else
			render 'new'
		end
	end
	
	def edit
		@foodentry = FoodEntry.find(params[:id])
	end
	
	def update
		@foodentry = FoodEntry.find(params[:id])
		
		if @foodentry.update(food_entry_params)
			redirect_to food_entries_path
		else
			render 'edit'
		end
	end
	
	def destroy
		@foodentry = FoodEntry.find(params[:id])
		@foodentry.destroy
		
		redirect_to food_entries_path
	end
	
	private
	
	def food_entry_params
		params.require(:food_entry)
			  .permit(:description, :calories, :fat, :carbs, :protein)
	end
end
