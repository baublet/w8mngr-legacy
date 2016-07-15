class CreateActivityEntries < ActiveRecord::Migration
  def change
    create_table :activity_entries do |t|
      t.references :activity, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.references :routine, index: true, foreign_key: true
      t.integer :day, limit: 8
      t.integer :reps, limit: 4
      t.integer :weight

      t.timestamps null: false
    end
  end
end
