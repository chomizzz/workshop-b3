class ConversationController < ApplicationController
  # before_action :find_user_by_nickname
  before_action :set_user
  before_action :set_conversation, only: [ :show, :load_messages, :send_message ]

  def index
    # @conversations = current_user.conversations.includes(:users, :messages)
    # @conversation = @conversations.first
    @contacts = current_user.contacts
    @new_message = Message.new
    # if @conversation
    #   @messages = @conversation.messages
    # end
  end

  def show
    @messages = @conversations.ordered_messages
    @new_message = Message.new
  end

  def load_messages
    @messages = @conversation.ordered_messages

    @new_message = Message.new


    render turbo_stream: [
      turbo_stream.update(
        "conversation-section", # Nouveau target
        partial: "conversation_section", # Nouvelle partial
        locals: {
          messages: @messages,
          new_message: @new_message,
          conversation: @conversation,
          other_user: @other_user,
          user: @user
        }
      )
    ]
  end

  def send_message
    @conversation.send_message(@user, params[:content])
    render turbo_stream: [
      turbo_stream.update(
        "conversation_form",
        partial: "conversation_form",
        locals: {
          conversation: @conversation,
          current_user: @user
        }
      )
    ]
  end


  private

  def set_user
    @user = current_user
  end

  def set_conversation
    puts @user.inspect
    @conversation = @user.conversations.find(params[:id])
  rescue ActiveRecord::RecordNotFound
      redirect_to user_conversations_path(@user.nickname), alert: "Conversation non trouvée"
  end

  def find_user_by_nickname
    @user = User.find_by!(nickname: params[:nickname])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: "Utilisateur non trouvé"
  end
end
