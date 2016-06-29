class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.references :user, index: true, foreign_key: true
      t.text :title, limit: 96
      t.text :description
      t.text :exrx
      t.integer :type, limit: 2
      t.integer :muscle_groups, limit: 3
      t.integer :popularity

      t.timestamps null: false
    end
  end
end
