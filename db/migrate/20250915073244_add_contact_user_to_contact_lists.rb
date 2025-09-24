class AddContactUserToContactLists < ActiveRecord::Migration[8.0]
  def change
    add_reference :contact_lists, :contact_user, null: false, foreign_key: { to_table: :users }
  end
end
