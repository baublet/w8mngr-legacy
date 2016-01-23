class CreateFoodEntries < ActiveRecord::Migration
  def change
    create_table :food_entries do |t|
      t.string :description
      t.integer :calories
      t.integer :fat
      t.integer :carbs
      t.integer :protein

      t.timestamps null: false
    end
  end
end
