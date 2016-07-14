class ExpandSizeOfCaloriesColumn < ActiveRecord::Migration
  def change
     change_table :activity_entries do |t|
      t.change :calories, :decimal, precision: 15, scale: 2, default: 0
    end
  end
end
