class AddCaloriesColumnToActivityEntries < ActiveRecord::Migration
  def change
    add_column :activity_entries, :calories, :decimal, precision: 5, scale: 2, default: 0
  end
end
