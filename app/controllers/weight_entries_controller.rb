class WeightEntriesController < ApplicationController
  before_action :logged_in_user

  # GET /weight_entries
  def index
    show_list
  end

  # POST /weight_entries
  def create
    @weightentry = current_user.weightentries.build(weight_entry_params)
    @weightentry.update_value params[:weight_entry][:value]

    if @weightentry.save
        flash[:success] = "Weight entry added"
        redirect_to weight_log_day_path(current_day)
    else
        @newweightentry = @weightentry
        @newweightentry.value = params[:weight_entry][:value]
        flash.now[:error] = "Failed to add weight entry"
        show_list
    end
  end

  # DELETE /weight_entries/1
  def destroy
    @weightentry = current_user.weightentries.find(params[:id])
    @current_day = @weightentry.day
    @weightentry.destroy
    redirect_to weight_log_day_path(current_day)
  end

  private
    # Renders the list of weight entries for this day
    def show_list
        @weightentries = current_user.weightentries_from(current_day).all
        @weight_average = current_user.weight_average_display(current_day, '<span class="unit">', '</span>')
        @newweightentry ||= current_user.weightentries.build(day: current_day)
        render :index
    end

    # Only allow a trusted parameter "white list" through.
    def weight_entry_params
      params.require(:weight_entry).permit(:day)
    end
end
