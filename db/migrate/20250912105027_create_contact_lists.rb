class CreateContactLists < ActiveRecord::Migration[8.0]
  def change
    create_table :contact_lists do |t|
      t.references :user, null: false, foreign_key: true
      t.string :nickname

      t.timestamps
    end
  end
end
