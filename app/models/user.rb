class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :community, optional: true

  has_many :contact_lists, dependent: :destroy
  has_many :contacts, through: :contact_lists, source: :contact
  has_many :conversation_users, dependent: :destroy
  has_many :conversations, through: :conversation_users


  validates :nickname, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true

  def add_contact(other_user)
    return nil unless other_user.is_a?(User)

    unless contacts.include?(other_user)
      contact_lists.create(contact: other_user)
    end
  end

  def remove_contact(other_user)
    contact_list = contact_lists.find_by(contact: other_user)
    contact_list&.destroy
    conversation = find_conversation_with(other_user)
    conversation&.destroy
  end

  def create_conversation(other_user)
    existing_conversation = find_conversation_with(other_user)
    return existing_conversation if existing_conversation

    conversation = Conversation.create!(title: "#{self.nickname} & #{other_user.nickname}")
    conversation.conversation_users.create!(user: self)
    conversation.conversation_users.create!(user: other_user)

    conversation
  end

  def find_conversation_with(other_user)
    (self.conversations & other_user.conversations).find do |conversation|
      conversation.users.count == 2
    end
  end
end
