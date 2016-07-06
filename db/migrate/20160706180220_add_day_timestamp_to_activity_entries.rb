class AddDayTimestampToActivityEntries < ActiveRecord::Migration
  def change
    add_column :activity_entries, :day_ts, :timestamp, null: false, default: Time.now
  end
end
