class CreateMeasurements < ActiveRecord::Migration
  def change
    create_table :measurements do |t|
      t.integer :amount
      t.string :unit
      t.integer :calories
      t.integer :fat
      t.integer :carbs
      t.integer :protein
      t.references :food, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
