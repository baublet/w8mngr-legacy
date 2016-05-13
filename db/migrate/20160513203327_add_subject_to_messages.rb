class AddSubjectToMessages < ActiveRecord::Migration
  def change
    add_column :pt_messages, :subject, :text, null: true
  end
end
