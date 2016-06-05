class WeightEntriesDataController < ApplicationController
  before_action :logged_in_user

  def index
    data = process_data
    respond_to do |format|
      format.json { render json: data }
    end
  end

  private

  def process_data
    id = current_user.id
    length = params[:num].to_i
    length_scope = params[:length_scope]
    data = WeightEntryData.new(user_id: id, num: length, length_scope: length_scope)
    return data.time_data
  end

end