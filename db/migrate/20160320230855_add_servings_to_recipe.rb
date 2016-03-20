class AddServingsToRecipe < ActiveRecord::Migration
  def change
    add_column :recipes, :servings, :integer
  end
end
