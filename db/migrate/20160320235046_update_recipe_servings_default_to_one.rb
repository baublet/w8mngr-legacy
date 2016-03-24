class UpdateRecipeServingsDefaultToOne < ActiveRecord::Migration
  def change
    change_column_default(:recipes, :servings, 1)
  end
end
