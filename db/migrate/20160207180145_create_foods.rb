class CreateFoods < ActiveRecord::Migration
  def change
    create_table :foods do |t|
      t.text        :name,          limit: 255,  index: true, null: false
      t.text        :description
      t.text        :ndbno,         limit: 8
      t.text        :upc,           limit: 12
      t.integer     :popularity,    default: 0
      t.integer     :likes,         default: 0

      t.references  :user,          index: true,    foreign_key: true

      t.timestamps  null: false
    end
  end
end
