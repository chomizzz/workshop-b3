class AddLocationToCommunities < ActiveRecord::Migration[8.0]
  def change
    add_reference :communities, :location, null: true, foreign_key: true
  end
end
