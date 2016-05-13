class AddMessageHtmlToPtMessages < ActiveRecord::Migration
  def change
    add_column :pt_messages, :message_html, :text, null: true
  end
end
