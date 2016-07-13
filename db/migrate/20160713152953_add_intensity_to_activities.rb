class AddIntensityToActivities < ActiveRecord::Migration
   def change
    add_column :activities, :intensity, :integer, limit: 1, default: 0
  end
end
