class CreateFoodEntries < ActiveRecord::Migration
  def change
    create_table :food_entries do |t|
      t.string :description
      t.integer :calories,  null: false, default: 0
      t.integer :fat
      t.integer :carbs
      t.integer :protein
      t.integer :day,       null: false
      t.references :user,   index: true, foreign_key: true

      t.timestamps null: false
    end
    add_index :food_entries, [:user_id, :day, :created_at]
  end
end
