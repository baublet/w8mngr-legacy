class MakeRoutinesActivitiesColumnAnArray < ActiveRecord::Migration
  def change
    remove_column :routines, :activities
    add_column :routines, :activities, :integer, array: true, default: []
  end
end
