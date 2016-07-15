class AddSoftDeleteActivities < ActiveRecord::Migration
  def change
    add_column :activities, :deleted, :boolean, null: false, default: false
  end
end
