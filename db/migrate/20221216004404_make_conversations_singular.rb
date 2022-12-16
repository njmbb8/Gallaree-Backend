class MakeConversationsSingular < ActiveRecord::Migration[6.1]
  def change
    rename_column :messages, :conversations_id, :conversation_id
  end
end
