class Conversation < ApplicationRecord
  has_many :conversation_users, dependent: :destroy
  has_many :users, through: :conversation_users
  has_many :messages, dependent: :destroy

  def send_message(user, content)
    return nil if content.blank?

    message = messages.create!(
      content: content.strip,
      user: user,
    )
    message
  end

  def ordered_messages
    messages.includes(:user).order(created_at: :desc)
  end
end
