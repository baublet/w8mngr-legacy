class AddMoodToPtMessage < ActiveRecord::Migration
  def change
    add_column :pt_messages, :mood, :integer, limit: 1, default: 0
  end
end
