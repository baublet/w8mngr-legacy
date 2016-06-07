class AddDayTsColumntoDayNavigatorTalbes < ActiveRecord::Migration
  def change
    add_column :food_entries, :day_ts, :timestamp, null: false, default: Time.now
    add_column :weight_entries, :day_ts, :timestamp, null: false, default: Time.now
  end
end
