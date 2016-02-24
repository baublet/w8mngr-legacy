class WeightEntriesController < ApplicationController
  before_action :set_weight_entry, only: [:show, :edit, :update, :destroy]

  # GET /weight_entries
  def index
    @weightentries = current_user.weightentries_from(current_day).all
    @weight_average = current_user.weight_average(current_day)
    @newweightentry = current_user.weightentries.build(day: current_day)
  end

  # GET /weight_entries/1
  def show
  end

  # GET /weight_entries/new
  def new
    @weightentry = WeightEntry.new
  end

  # GET /weight_entries/1/edit
  def edit
  end

  # POST /weight_entries
  def create
    @weight_entry = WeightEntry.new(weight_entry_params)

    if @weight_entry.save
      redirect_to @weight_entry, notice: 'Weight entry was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /weight_entries/1
  def update
    if @weight_entry.update(weight_entry_params)
      redirect_to @weight_entry, notice: 'Weight entry was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /weight_entries/1
  def destroy
    @weight_entry.destroy
    redirect_to weight_entries_url, notice: 'Weight entry was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_weight_entry
      @weight_entry = WeightEntry.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def weight_entry_params
      params.require(:weight_entry).permit(:value, :day, :user_id)
    end
end
