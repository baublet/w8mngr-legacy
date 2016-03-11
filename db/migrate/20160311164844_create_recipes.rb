class CreateRecipes < ActiveRecord::Migration
  def change
    create_table :recipes do |t|
      t.text :name
      t.text :description
      t.text :instructions

      t.timestamps null: false
    end
  end
end
