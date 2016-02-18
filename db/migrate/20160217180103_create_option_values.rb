class CreateOptionValues < ActiveRecord::Migration
  def change
    create_table :option_values do |t|
      t.references :user, index: true, foreign_key: true
      t.references :option, index: true, foreign_key: true
      t.text :value

      t.timestamps null: false
    end
  end
end
