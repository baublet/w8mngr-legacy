class AddAmountToIngredients < ActiveRecord::Migration
  def change
    add_column :ingredients, :amount, :integer
  end
end
