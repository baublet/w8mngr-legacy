class FixPtMessageTypeColumnName < ActiveRecord::Migration
  def change
    rename_column :pt_messages, :type, :message_type
  end
end
