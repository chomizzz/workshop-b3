class Community < ApplicationRecord
  belongs_to :location, optional: true
  has_many :users
  has_many :items

  def add_user_to_community(new_user)
      new_user.update(community: self)
  end
end
