class RenameActivityEntryWeightToWork < ActiveRecord::Migration
  def change
    rename_column :activity_entries, :weight, :work
  end
end
