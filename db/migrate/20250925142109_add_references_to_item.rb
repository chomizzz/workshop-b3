class AddReferencesToItem < ActiveRecord::Migration[8.0]
  def change
    add_reference :items, :community, null: false, foreign_key: true
  end
end
