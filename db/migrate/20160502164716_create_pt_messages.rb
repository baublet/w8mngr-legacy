class CreatePtMessages < ActiveRecord::Migration
  def change
    create_table :pt_messages do |t|
      t.references :user, index: true, foreign_key: true
      t.integer :type, limit: 2, null: false
      t.string :uid, limit: 32, null: false
      t.text :message, null: false
      t.boolean :seen, default: false
      t.boolean :deleted, default: false

      t.timestamps null: false
    end
  end
end
