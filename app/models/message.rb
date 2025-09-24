class Message < ApplicationRecord
  belongs_to :user
  belongs_to :conversation
  after_create_commit :broadcast_message_to_participants

  encrypts :content

  def broadcast_message_to_participants
    conversation.users.each do |participant|
      broadcast_update_to(
        "conversation_#{self.conversation.id}_user_#{participant.id}",
        target: "conversation",
        partial: "conversation/conversation",
        locals: {
          messages: self.conversation.ordered_messages,
          conversation: self.conversation,
          current_user: participant
        }
      )
    end
  end
end
