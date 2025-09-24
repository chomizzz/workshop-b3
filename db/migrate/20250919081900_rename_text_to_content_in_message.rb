class RenameTextToContentInMessage < ActiveRecord::Migration[8.0]
  def change
    rename_column :messages, :text, :content
  end
end
