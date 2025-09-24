class RenameContactUserIdInContactLists < ActiveRecord::Migration[8.0]
  def change
    rename_column :contact_lists, :contact_user_id, :contact_id
  end
end
