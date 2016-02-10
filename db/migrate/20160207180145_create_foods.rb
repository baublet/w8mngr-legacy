class CreateFoods < ActiveRecord::Migration
  def change
    create_table :foods do |t|
      t.string      :name
      t.string      :description
      t.integer     :food_type, default: 0
      t.integer     :calories
      t.integer     :fat
      t.integer     :carbs
      t.integer     :protein
      t.integer     :amount
      t.integer     :measurement
      t.integer     :serving_size
      
      t.references  :user,   index: true, foreign_key: true
      t.integer     :public, default: 0

      t.timestamps  null: false
    end
  end
end
