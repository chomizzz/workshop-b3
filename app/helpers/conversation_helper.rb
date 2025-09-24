module ConversationHelper
  def conversation_id_with_contact(contact)
    # retourne une conversation
    current_user.conversations.joins(:users).where(users: { id: contact.id }).first
  end
end
