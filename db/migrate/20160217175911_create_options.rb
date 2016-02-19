class CreateOptions < ActiveRecord::Migration
  def change
    create_table :options do |t|
      t.string  :name,  limit: 32
      t.string  :kind,  limit: 1, default: "s"
      t.text    :values
      t.text    :default_value

      t.timestamps null: false
    end
  end
end
