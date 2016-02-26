class WeightEntriesController < ApplicationController
  before_action :set_weight_entry, only: [:show, :edit, :update, :destroy]

  # GET /weight_entries
  def index
    show_list
  end

  # POST /weight_entries
  def create
    @weightentry = current_user.weightentries.build(weight_entry_params)
    @weightentry.update_value params[:weight_entry][:value]

    if @weightentry.save
        @newweightentry = current_user.weightentries.build(day: current_day)
        flash.now[:success] = "Weight entry added"
    else
        @newweightentry = @weightentry
        @newweightentry.value = params[:weight_entry][:value]
        flash.now[:error] = "Failed to add weight entry"
    end
    show_list
  end

  # PATCH/PUT /weight_entries/1
  def update
    if @weightentry.update(weight_entry_params)
      @newweightentry = current_user.weightentries.build(day: current_day)
    end
    show_list
  end

  # DELETE /weight_entries/1
  def destroy
    @weightentry.destroy
    show_list
  end

  private
    # Renders the list of weight entries for this day
    def show_list
        @weightentries = current_user.weightentries_from(current_day).all
        @weight_average = current_user.weight_average(current_day)
        @newweightentry ||= current_user.weightentries.build(day: current_day)
        render :index
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_weight_entry
      @weightentry = current_user.weightentries.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def weight_entry_params
      params.require(:weight_entry).permit(:day, :user_id)
    end
end
