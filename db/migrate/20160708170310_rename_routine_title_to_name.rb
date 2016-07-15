class RenameRoutineTitleToName < ActiveRecord::Migration
  def change
    rename_column :routines, :title, :name
  end
end
