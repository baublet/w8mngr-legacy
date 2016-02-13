class CreateMeasurements < ActiveRecord::Migration
  def change
    create_table :measurements do |t|
      t.text        :amount,    limit: 5, null: false
      t.text        :unit,      limit: 96,null: false
      t.integer     :calories,  limit: 5, null: false
      t.integer     :fat,       limit: 4, null: false
      t.integer     :carbs,     limit: 4, null: false
      t.integer     :protein,   limit: 4, null: false
      t.integer     :popularity, default: 0
      t.references  :food,       index: true, foreign_key: true

      t.timestamps  null: false
    end
  end
end
