class CreateIngredients < ActiveRecord::Migration
  def change
    create_table :ingredients do |t|
      t.references :recipe
      t.references :measurement
      t.text       :name
      t.integer    :calories
      t.integer    :fat
      t.integer    :carbs
      t.integer    :protein

      t.timestamps null: false
    end
  end
end
