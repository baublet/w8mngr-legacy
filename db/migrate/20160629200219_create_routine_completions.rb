class CreateRoutineCompletions < ActiveRecord::Migration
  def change
    create_table :routine_completions do |t|
      t.references :routine, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.integer :day, limit: 8
      t.text :notes

      t.timestamps null: false
    end
  end
end
