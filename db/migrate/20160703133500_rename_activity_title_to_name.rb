class RenameActivityTitleToName < ActiveRecord::Migration
  def change
    rename_column :activities, :title, :name
  end
end
