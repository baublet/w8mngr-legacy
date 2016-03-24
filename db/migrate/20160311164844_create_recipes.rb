class CreateRecipes < ActiveRecord::Migration
  def change
    create_table :recipes do |t|
      t.text        :name,          limit: 255, index: true, null: false
      t.text        :description
      t.text        :instructions
      t.references  :user,          index: true, foreign_key: true
      t.integer     :popularity,    default: 0
      t.integer     :likes,         default: 0

      t.timestamps null: false
    end
  end
end
