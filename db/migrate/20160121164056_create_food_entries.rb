class CreateFoodEntries < ActiveRecord::Migration
  def change
    create_table :food_entries do |t|
      t.text       :description,null: false
      t.integer    :calories,   null: false, default: 0, limit: 5
      t.integer    :fat,        limit: 3
      t.integer    :carbs,      limit: 3
      t.integer    :protein,    limit: 3
      t.integer    :day,        null: false
      t.references :user,       index: true, foreign_key: true

      t.timestamps null: false
    end
    add_index :food_entries, [:user_id, :day, :created_at]
  end
end
