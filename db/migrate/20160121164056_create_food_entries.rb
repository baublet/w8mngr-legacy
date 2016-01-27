class CreateFoodEntries < ActiveRecord::Migration
  def change
    create_table :food_entries do |t|
      t.string :description
      t.integer :calories
      t.integer :fat
      t.integer :carbs
      t.integer :protein
      t.integer :day
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
    add_index :food_entries, [:user_id, :day, :created_at]
  end
end
