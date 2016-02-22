class CreateWeightEntries < ActiveRecord::Migration
  def change
    create_table :weight_entries do |t|
      t.integer :value
      t.integer :day
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
