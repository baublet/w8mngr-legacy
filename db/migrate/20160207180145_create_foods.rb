class CreateFoods < ActiveRecord::Migration
  def change
    create_table :foods do |t|
      t.string      :name,      index: true
      t.string      :description
      t.string      :ndbno

      t.references  :user,      index: true, foreign_key: true

      t.timestamps  null: false
    end
  end
end
