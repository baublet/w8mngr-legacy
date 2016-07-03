class CreateRoutines < ActiveRecord::Migration
  def change
    create_table :routines do |t|
      t.references :user, index: true, foreign_key: true
      t.text :title, limit: 96
      t.text :description
      t.hstore :activities
      t.integer :last_completion, limit: 8

      t.timestamps null: false
    end
  end
end
